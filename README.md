## Live Demo
View the live app [at heroku.](https://stockup-trading.herokuapp.com/)

## Introduction

A project to explore Test-driven development (TDD).

## Screenshots

<!-- <p float = 'left'>
    <img src="app/assets/images/Blog-App-1.png" alt="Blog Screenshot 1" width="500" height="300">
    <img src="app/assets/images/Blog-App-2.png" alt="Blog Screenshot 2" width="500" height="300">
</p> -->

## App Architecture:

## Technologies

* Ruby v2.7.2
* Ruby on Rails v6.0.3.4
* NodeJS 12.18.3
* Yarn 1.22.4
* CSS and SCSS
* PostgresQL
<!-- * [Trix](https://github.com/basecamp/trix)
* `toastr` for notifications
* `image-processing` gem -->

#### Setup

```
  $ bundle install
  $ yarn install --check-files
  $ bundle exec rails webpacker:install
  $ rails db:setup
```
Note: `database.yml` uses ENV variables to fetch database username and password. See this [stackoverflow thread](https://stackoverflow.com/a/17151962/15233426) for more details.