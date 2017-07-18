## Raven 
* Production error monitoring  
* install gem `sentry-raven`  

## Continuous integration with CircleCI  
* Create circleCI account  

* link github to circirCI  

* config circleCI account with heroku ssh, keys  

* include `/circle.yml` file in project  
~> create staging branch  
~> create staging server which features as same as production  
~> when push staging or master circle.yml will tell circleCI to deploy to heroku  
```ruby
#circle.yml sample version 1.0
machine:
  ruby:
    version: 2.2.7
deployment:
  production:
    branch: master
    commands:
      - heroku maintenance:on --app p-kuttiya-myflix
      - heroku pg:backups capture --app p-kuttiya-myflix
      - git push git@heroku.com:p-kuttiya-myflix.git $CIRCLE_SHA1:refs/heads/master
      - heroku maintenance:off --app p-kuttiya-myflix
      - heroku run rake db:migrate
      - heroku run rake db:reset
      - heroku restart
  staging:
    branch: staging
    commands:
      - heroku maintenance:on --app pkuttiya-myflix-staging
      - git push git@heroku.com:pkuttiya-myflix-staging.git $CIRCLE_SHA1:refs/heads/master
      - heroku maintenance:off --app pkuttiya-myflix-staging
      - heroku run rake db:migrate
      - heroku run rake db:reset
      - heroku restart
dependencies:
  pre:
    - gem install bundler
```

## Workflow for creating new features  
~> clone repo/pull latest code  
~> create new branch, implement desired code  
~> push that branch to github  
~> create pull request implemented branch to staging branch    
~> wait for ci to auto run test for staging and will deploy to heroku staging server if passed  
~> test staging server UI if everthing is passed  
~> create pull request from staging branch to master on github  
~> CI will test and deploy  