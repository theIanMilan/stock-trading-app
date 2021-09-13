## Live Demo
View the live app [at heroku.](https://stockup-trading.herokuapp.com/)

## Introduction

StockUp-Trading is a project made by [Ian Mandap](https://github.com/theIanMilan) and [Miguel Calderon](https://github.com/miguel425) that allows users to sign up and simulate trades of NASDAQ-100 listed stocks. Trades are made possible through an ordering system whereby upon order creation, the backend checks for matching buy/sell order pairs and executes the transaction.  

The goal in building this app was to learn about test driven development through RSpec, advanced database associations (e.g. has_many :through association), callbacks, API integration, method scoping, and the skinny controller, and fat model concept.

## Screenshots

<!-- <p float = 'left'>
    <img src="app/assets/images/Blog-App-1.png" alt="Blog Screenshot 1" width="500" height="300">
    <img src="app/assets/images/Blog-App-2.png" alt="Blog Screenshot 2" width="500" height="300">
</p> -->

## App Architecture/ Entity Relationship Diagram:
<p float = 'left'>
    <img src="https://user-images.githubusercontent.com/66746718/132863676-ba8bc3d0-bdeb-4662-9444-0b99c230112e.jpg" width="400" height="400">
</p>

## Technologies

* Ruby v2.7.2
* Ruby on Rails v6.0.3.4
* NodeJS 12.18.3
* Yarn 1.22.4
* CSS and SCSS
* PostgresQL
* Bootstrap
* `devise` gem for authentication
* `cancancan` gem for authorization
* `rails_admin` gem for Admin dashboard
* `iex-ruby-client` gem for Stock info API
* `factory_bot_rails` gem
* `faker` gem

#### Setup

```
  $ bundle install
  $ yarn install --check-files
  $ bundle exec rails webpacker:install
  $ rails db:setup
  $ sudo apt-get install chromium-chromedriver
```

#### To-Dos
* Mobile Responsiveness
* Add percent change in stocks
* Add JavaScript to Order forms to compute totals
* Market charts for stocks
* CSS Styling for `devise` views
