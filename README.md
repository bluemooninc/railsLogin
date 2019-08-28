# Ruby on Rails user registration sample

## Getting start

You need a docker, git for your local computer.

## Build docker images

Download or clone from this Github repository.

```
# Clone this repository
git clone https://github.com/bluemooninc/railsLogin.git

# Boot docker container Rails and PostgreSQL
cd railsLogin
docker-compose up -d
```

## Start web server

```
# SSH login to docker image
docker exec -it railslogin_web_1 bash

# install middleware
cd Login
npm init -y
npm install --save-dev webpack
npm install --save-dev webpack-cli
yarn install --check-files
bundle install
rake db:migrate
./bin/rails webpacker:install
./bin/rails webpacker:install:vue
bin/webpack

# Start the web server
rails s -b 0.0.0.0
=> Booting Puma
=> Rails 6.0.0 application starting in development
=> Run `rails server --help` for more startup options
Puma starting in single mode...
* Version 3.12.1 (ruby 2.5.0-p0), codename: Llamas in Pajamas
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop

```

## Check from your local browser

```
http://localhost:3000/
```

## Check the email from your local browser

You can check your email from web server.

```
http://localhost:3000/letter_opener
```


## Specification

- As a user, you can visit sign up page and sign up with your email (with valid format and unique in database) and password (with confirmation and at least eight characters).
- When you sign up successfully, You would see your profile page.
- When you sign up successfully, You would receive a welcome email.
- When you sign up incorrectly, You would see error message in sign up page.
- As a user, you can edit my username and password in profile page. You can also see your email in the page but You can not edit it.
- When you first time entering the page, your username would be my email prefixing, e.g. (email is “user@example.com” , username would be “user”)
- When you edit my username, it should contain at least five characters. (Default username does not has this limitation)
- As a user, You can log out the system.
- When I log out, I would see the login page.
- As a user, You can visit login page and login with your email and password.
- As a user, You can visit login page and click “forgot password” if You forgot your password.
- When you visit forgot password page, You can fill my email and ask the system to send reset password email.
- As a user, You can visit reset password page from the link inside reset password email and reset your password (with confirmation and at least eight characters).
- The link is only valid within six hours.

## System Enviroment

- PostgreSQL database container
- It not use third party library for user registration. (e.g. Devise)
- As a locale email system using letter_opener. ( https://github.com/ryanb/letter_opener for the email in development environment. )
