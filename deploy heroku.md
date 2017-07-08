install heroku CLI
ubuntu: wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

-git files need to be root repo
-go into folder
-clone repo/pull with git desktop
-heroku login
-heroku create app-name

-modify on heroku web --> setting for app for package build to node.js

-git add -A
-git push heroku master

**For rails
-heroku run rake db:migrate

if error 
fatal: 'heroku' does not appear to be a git repository
fatal: Could not read from remote repository.

-heroku login
heroku git:remote -a yourapp
add and push heroku master

