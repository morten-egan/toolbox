#!/bin/bash
export PROJECTNAME=$1
export PROJECTHOME=$HOME/Kode/Projects/$1

if [ -d $PROJECTHOME ]; then
	echo "Project already exists"
else
	echo "Creating project $PROJECTNAME"
	# Create project home
	mkdir $PROJECTHOME
	# Create project command file
	touch $PROJECTHOME/.qs_commands
	# Create bin directory for executables
	mkdir $PROJECTHOME/bin
	# Create project readme file
	touch $PROJECTHOME/README.md
	echo "Project $PROJECTNAME readme file" >> $PROJECTHOME/README.md
	# Create GIT repository for project
	cd $PROJECTHOME
	git init
	git add README.md
	git commit -m "$PROJECTNAME first commit"
	# Create repository on GitHub
	# Expect GIT OAuth token to be located in $HOME/Access/.git_oauth_token
	if [ -f $HOME/Access/.git_oauth_token ]; then
		git_token=$(<$HOME/Access/.git_oauth_token)
		echo $git_token
		curl -i -H "Authorization: token $git_token" \
     	-d '{ "name": "$PROJECTNAME" }' \
      	https://api.github.com/user/repos
    else
    	echo "Unable to find Git OAuth token. No Github repo created"
    fi

    echo "Project: $PROJECTNAME created."
fi