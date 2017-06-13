* start new git  
~> `git init`  
~> `git remote add origin https://github.com/username/project_name.git`  

* switch project  
~> `git remote set-url origin https://github.com/username/project_name.git`

* switch branch  
~> `git checkout [branch_name]`

* create new branch  
~> `git chechout [branch_name] -b`

* disable username and pass input validation  
~> `git config -l`  
~> `git config remote.origin.url https://{username}:{password}@github.com/{username}/{repo}.git`