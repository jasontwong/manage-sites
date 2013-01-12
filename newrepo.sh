#!/bin/bash -e
# usage: ./newrepo.sh REPO_NAME
GITREPOSDIR="/path/to/repos"
NEWREPO="$GITREPOSDIR/$1.git"
WEBDIR="/path/to/internal/vhosts/$1/webroot"
 
# Directory $NEWREPO already exists
if [ ${#1} -lt 3 ] || [ -d "$NEWREPO" ]; then
	exit 1
fi
 
# Creating webdir $WEBDIR...
if [ ! -d "$WEBDIR" ]; then
	mkdir -p "$WEBDIR"
fi
 
# Creating dir for new repo at $NEWREPO...
mkdir -p "$NEWREPO"
cd "$NEWREPO"
git init --bare
# Configuring post-receive hook...
touch "hooks/post-receive"
echo "#!/bin/sh" >> "hooks/post-receive"
echo "GIT_WORK_TREE=$WEBDIR git checkout -f" >> "hooks/post-receive"
chmod 755 "hooks/post-receive"
