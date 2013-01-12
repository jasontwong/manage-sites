import bottle, os, subprocess, stat, datetime, tarfile

# {{{ def routeapp(obj):
def routeapp(obj):
    for kw in dir(obj):
        attr = getattr(obj, kw)
        if hasattr(attr, 'error'):
            bottle.error(attr.error)(attr)
        if hasattr(attr, 'delete'):
            bottle.delete(attr.delete)(attr)
        if hasattr(attr, 'put'):
            bottle.put(attr.put)(attr)
        if hasattr(attr, 'post'):
            bottle.post(attr.post)(attr)
        if hasattr(attr, 'route'):
            bottle.route(attr.route)(attr)
# }}}

class App(object):
    # {{{ def route(route):
    def route(route):
        def decorator(f):
            f.route = route
            return f
        return decorator
    # }}}
    # {{{ def post(route):
    def post(route):
        def decorator(f):
            f.post = route
            return f
        return decorator
    # }}}
    dir = {
        'internal': '/path/to/internal/vhosts',
        'external': '/path/to/external/vhosts'
    }
    repo_script = os.getcwd() + '/newrepo.sh'
    # {{{ def scan(self):
    def scan(self):
        '''Scans self.dir directories to get the latest list of sites'''
        self.paths = {
            'internal': [],
            'external': [],
        }
        folder_excludes = [
            'Network Trash Folder', 
            'Temporary Items'
        ]
        for side in ('external', 'internal'):
            for path in os.listdir(self.dir[side]):
                file = '/'.join((self.dir[side], path))
                if os.path.isdir(file) and path[0] is not '.' and path not in folder_excludes:
                    self.paths[side].append(path)
        self.paths['internal'] = sorted(self.paths['internal'])
    # }}}
    @route('/')
    def index(self):
        self.scan()
        return bottle.template('index', self.paths)

    @route('/images/:filename')
    def images(self, filename):
        return bottle.static_file(filename, root='images')

    @route('/close/:site')
    def close(self, site):
        '''Makes the example.com subdomain hidden from the public'''
        self.scan()
        if site in self.paths['external']:
            e = '/'.join((self.dir['external'], site))
            os.unlink(e)
        bottle.redirect('/')
    
    @route('/open/:site')
    def open(self, site):
        '''Makes the example.com subdomain open to the public'''
        self.scan()
        if not site in self.paths['external']:
            e = '/'.join((self.dir['external'], site))
            i = '/'.join((self.dir['internal'], site))
            os.symlink(i, e)
        bottle.redirect('/')

    @post('/create/')
    def create(self):
        '''Makes a new repo and subdomain for example.com'''
        site = bottle.request.forms.get('site')
        if (site != None and len(site) > 0 ):
            subprocess.call([repo_script, site], stdout=subprocess.PIPE)
        bottle.redirect('/')

    @route('/backup/:site')
    def backup(self, site):
        '''Makes a backup tarball of the example.com subdomain'''
        self.scan()
        if site in self.paths['internal']:
            b = '/'.join((self.dir['internal'], site, 'backups'))
            if not os.path.exists(b):
                os.mkdir(b)
                if os.path.exists(b):
                    dchmod = stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO
                    os.chmod(b, dchmod)
            if os.path.exists(b):
                now = datetime.datetime.now()
                stamp = now.strftime('%Y%m%d-%H%M')
                filename = b + '/%s.example.com-%s.tar.gz' % (site, stamp)
                fchmod = stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO
                webroot = '/'.join((self.dir['internal'], site, 'webroot'))
                tarball = tarfile.open(name=filename, mode='w:gz')
                tarball.add(webroot, arcname='webroot', recursive=True)
                os.chmod(filename, fchmod)
        bottle.redirect('/')

    route = staticmethod(route)
    post = staticmethod(post)

routeapp(App())
bottle.debug(True)
bottle.run(host='sites.example.com', port=6002, reloader=True)
