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
	# Create temp directory (will be excluded from git)
	mkdir $PROJECTHOME/temp
	# Create project readme file
	touch $PROJECTHOME/README.asciidoc
	echo "= $PROJECTNAME" >> $PROJECTHOME/README.asciidoc
	echo "Morten Egan <morten@plsql.ninja>" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "This is the initial readme of the project. More will be added later. Like a description of what this is" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "[NOTE]" >> $PROJECTHOME/README.asciidoc
	echo "Since this is the first check-in, not much info has been added yet." >> $PROJECTHOME/README.asciidoc
	echo "But he will do soon." >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "== Summary" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "== Pre-requisites" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "== Installation" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "== Procedures and Functions" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	echo "== Examples" >> $PROJECTHOME/README.asciidoc
	echo " " >> $PROJECTHOME/README.asciidoc
	# Create GIT repository for project
	cd $PROJECTHOME
	git init >> $HOME/create_project_$PROJECTNAME.log
	git add README.asciidoc >> $HOME/create_project_$PROJECTNAME.log
	# Add an ignore file to the repository
	touch $PROJECTHOME/.gitignore
	echo "# Ignore list" >> $PROJECTHOME/.gitignore
	echo "*.py[cod]" >> $PROJECTHOME/.gitignore
	echo ".qs_env" >> $PROJECTHOME/.gitignore
	echo "*.sublime-project" >> $PROJECTHOME/.gitignore
	echo ".qs_commands" >> $PROJECTHOME/.gitignore
	echo "temp/" >> $PROJECTHOME/.gitignore
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
