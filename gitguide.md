* start new git  
~> `git init`  
~> `git remote add origin https://github.com/username/project_name.git`  

* switch project  
~> `git remote set-url origin https://github.com/username/project_name.git`

* switch branch  
~> `git checkout [branch_name]`

* create new branch  
~> `git chechout [branch_name] -b`

* disable username and pass input validation for certain project  
~> `git config -l`  
~> `git config remote.origin.url https://{username}:{password}@github.com/{username}/{repo}.git`

* timeout user validation  
~> `git config --global url."https//{username}@github.com".insteadOf "https://github.com"`  
~> `git config --global credential.helper 'cache --timeout=28800'`  

* store username and pass  
~> git config credential.helper store  
~> git push https://github.com/username/repo.git  
~> username:...  
~> password:... 

* delete branch  
~> git push origin --delete branch_name 
