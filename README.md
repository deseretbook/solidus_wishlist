# Solidus Wishlist

[![CircleCI](https://circleci.com/gh/deseretbook/solidus_wishlist.svg?style=svg)](https://circleci.com/gh/deseretbook/solidus_wishlist)

A Solidus Wishlist extension enables multiple wishlists per user, as well as managing those as public (sharable) and private. It also includes the ability to notify a friend via email of a recommended product.

---

## Installation

Add the following to your `Gemfile`
```ruby
gem 'solidus_wishlist', github: 'deseretbook/solidus_wishlist'
gem 'solidus_email_to_friend', github: 'welitonfreitas/solidus_email_to_friend'
```

Run
```sh
$ bundle install
$ bundle exec rails g solidus_wishlist:install
```
Copyright (c) 2016 Deseret Book, released under the New BSD License
