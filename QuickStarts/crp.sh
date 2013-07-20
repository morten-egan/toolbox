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
	git init >> $HOME/create_project_$PROJECTNAME.log
	git add README.md >> $HOME/create_project_$PROJECTNAME.log
	git commit -m "$PROJECTNAME first commit" >> $HOME/create_project_$PROJECTNAME.log
	# Create repository on GitHub
	# Expect Github OAuth token to be located in $HOME/Access/.git_oauth_token
	# Expect Github username to be located in $HOME/Access/.git_username
	# Expect Github password to be located in $HOME/Access/.git_password
	if [ -f $HOME/Access/.git_oauth_token ]; then
		git_token=$(<$HOME/Access/.git_oauth_token)
		git_username=$(<$HOME/Access/.git_username)
		git_password=$(<$HOME/Access/.git_password)
		# Create new repository
		curl -i -H "Authorization: token $git_token" \
     	-d "{ \"name\": \"$PROJECTNAME\" }" \
      	https://api.github.com/user/repos >> $HOME/create_project_$PROJECTNAME.log
      	# Add remote repository
      	git remote add origin https://github.com/$git_username/$PROJECTNAME.git >> $HOME/create_project_$PROJECTNAME.log
      	# Set remote URL to include password so remote push always is automatic.
      	git remote set-url origin https://$git_username:$git_password@github.com/$git_username/$PROJECTNAME.git >> $HOME/create_project_$PROJECTNAME.log
      	git push -u origin master >> $HOME/create_project_$PROJECTNAME.log
    else
    	echo "Unable to find Git OAuth token. No Github repo created"
    fi

    echo "Project: $PROJECTNAME created."
    echo "For a detailed logfile, look here:  $HOME/create_project_$PROJECTNAME.log"
fi