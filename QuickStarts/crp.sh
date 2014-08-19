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
	# Create project env file
	touch $PROJECTHOME/.qs_env
	# Create bin directory for executables and scripts
	mkdir $PROJECTHOME/bin
	# Create a sublime project file
	touch $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "{" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "	\"folders\":" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "	[" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "		{" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "			\"follow_symlinks\": true," >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "			\"path\": \"$PROJECTHOME\"" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "		}" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "	]" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	echo "}" >> $PROJECTHOME/$PROJECTNAME.sublime-project
	# Create project readme file
	touch $PROJECTHOME/README.md
	echo "#Project $PROJECTNAME readme file" >> $PROJECTHOME/README.md
	echo "This project has just been started by [Morten Egan](https://github.com/morten-egan). He has not yet" >> $PROJECTHOME/README.md
	echo "updated the readme file for this project. Dont worry, he will do so soon." >> $PROJECTHOME/README.md
	# Create GIT repository for project
	cd $PROJECTHOME
	git init >> $HOME/create_project_$PROJECTNAME.log
	git add README.md >> $HOME/create_project_$PROJECTNAME.log
	# Add an ignore file to the repository
	touch $PROJECTHOME/.gitignore
	echo "# Ignore list" >> $PROJECTHOME/.gitignore
	echo "*.py[cod]" >> $PROJECTHOME/.gitignore
	echo ".qs_env" >> $PROJECTHOME/.gitignore
	echo "*.sublime-project" >> $PROJECTHOME/.gitignore
	git commit -m "$PROJECTNAME - Project creation autocommit" >> $HOME/create_project_$PROJECTNAME.log
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
      	# Create an automatic post-commit hook, to push changes to Github
      	touch $PROJECTHOME/.git/hooks/post-commit
      	echo "#!/bin/bash" >> $PROJECTHOME/.git/hooks/post-commit
      	echo "git push origin master" >> $PROJECTHOME/.git/hooks/post-commit
      	chmod a+x $PROJECTHOME/.git/hooks/post-commit
      	# If git-cola is available, add a line to .qs_commands to start up git-cola during quickstart
      	echo "setsid git gui" >> $PROJECTHOME/.qs_commands
    else
    	echo "Unable to find Git OAuth token. No Github repo created"  >> $HOME/create_project_$PROJECTNAME.log
    fi

    echo "Project: $PROJECTNAME created."
    echo "For a detailed logfile, look here:  $HOME/create_project_$PROJECTNAME.log"
fi
