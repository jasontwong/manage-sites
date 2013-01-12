<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<title>kratedev.com sites</title>
<style>
/*{{{RESET*/
html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	font-weight: inherit;
	font-style: inherit;
	font-size: 100%;
	font-family: inherit;
	vertical-align: baseline;
}
/* remember to define focus styles! */
:focus {
	outline: 0;
}
body {
	line-height: 1;
	color: black;
	background: white;
}
ol, ul {
	list-style: none;
}
/* tables still need 'cellspacing="0"' in the markup */
table {
	border-collapse: separate;
	border-spacing: 0;
}
caption, th, td {
	text-align: left;
	font-weight: normal;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: "";
}
blockquote, q {
	quotes: "" "";
}

/*}}}*/
body { font-size: 62.5%; font-family: sans-serif; }
a { padding: 0em 0; text-decoration: none; color: #333; }
#legend { margin: 10px 20px; }
#legend li { clear: both; padding: 0 0 10px; height: auto; width: auto; }
#legend li img { vertical-align: text-bottom; }
#sites { clear: both; }
li { position: relative; display: block; float: left; margin: 1px; padding: 12px 6px 4px; width: 90px; height: 40px; text-align: center; font-size: 1.2em; }
li div { visibility: hidden; margin-top: 4px; }
li:hover div { visibility: visible; }
li.public { background-color: #DFD; }
li.private { background-color: #FDD; }
li.public:hover { background-color: #9EB; }
li.private:hover { background-color: #FAA; }
#new-repo { clear: both; margin: 10px 20px; }
#new-repo li { clear: both; padding: 0 0 10px; height: auto; width: auto; }
</style>

</head>
<body>

<div id='legend'>
    <ul>
        <li>
            <img src='/images/cross.png' alt=''>
            Hide the subdomain from the public
        </li>
        <li>
            <img src='/images/tick.png' alt=''>
            Open the subdomain to the public
        </li>
        <li>
            <img src='/images/box.png' alt=''>
            Make a quick backup of the subdomain
        </li>
    </ul>
</div>

<ul id='sites'>
% for sub in internal:
    % if sub in external:
        <li class='public'>
            <a href='http://{{sub}}.kratedev.com/'>{{sub}}</a>
            <div>
                <a title='hide {{sub}} from the public' href='/close/{{sub}}'><img src='/images/cross.png' alt=''></a>
                <a title='make a quick backup of {{sub}}' href='/backup/{{sub}}'><img src='/images/box.png' alt=''></a>
            </div>
        </li>
    % else:
        <li class='private'>
            <a href='http://{{sub}}.kratedev.com/'>{{sub}}</a>
            <div>
                <a title='open {{sub}} to the public' href='/open/{{sub}}'><img src='/images/tick.png' alt=''></a>
                <a title='make a quick backup of {{sub}}' href='/backup/{{sub}}'><img src='/images/box.png' alt=''></a>
            </div>
        </li>
    % end
% end
    <hr style="clear:both;visibility:hidden;" />
</ul>

<div id="new-repo">
    <ul>
        <li>
            <p>Submitting this form will create the subdomain, webroot folder, and a git repo</p>
        </li>
        <li>
            <form method="POST" action="/create/">
                <input type="text" name="site" placeholder="subdomain" />
                <button type="submit">Create subdomain and repo</button>
            </form>
        </li>
    </ul>
    <hr style="clear:both;visibility:hidden;" />
</div>
</body>
</html>
