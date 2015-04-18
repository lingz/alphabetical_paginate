# AlphabeticalPaginate

A lightweight and highly customizable pagination gem for Ruby on Rails that generates alphabetic pagination categories from Collections or Arrays. It allows you to select the field you want to paginate on. 

By default, it works with [Bootstrap Pagination](http://twitter.github.io/bootstrap/components.html#pagination) CSS and it is also fully compatible with the [will_paginate](https://github.com/mislav/will_paginate) in case you want to use both. 

AlphabeticalPaginate incorporates efficient javascript partial page rerendering techniques and loading animations but also is non-obtrusive and falls back to standard href links.

It has two modes - if you're working with MySQL, it allows for low level database regex queries. Otherwise, it uses a buffered search to build an array. You should be able to easily modify the gem to work with other SQL databases (please make a pull-request if you do!).

We also now have Russian language support and Bootstrap 3 support.

Some code was inspired by [will_paginate](https://github.com/mislav/will_paginate).


## Installation

Add this line to your application's Gemfile:  
```
    gem 'alphabetical_paginate'
```

And then execute:  
```bash
    $ bundle install
```

In case you're using the Rails 3.x assets pipeline remember to add it to your `production.rb` script:

```rb
  config.assets.precompile += %w( alphabetical_paginate.js )
```

## Basic Setup

Basic Pagination is as simple as adding a few lines to the controller and the view.

### Controller
You simply need to call alpha_paginate on the desired Active Record Collection (i.e. `User.alpha_paginate`) or on any array (`User.all.alpha_paginate`). This method takes two parameters, the first always being `params[:letter]` and the second being an optional options hash. 

Also, it takes a block in which you can specify the field you wish to paginate by (it can even be in another table). It returns the paginated subset of the collection, sorted by the pagination field. The method returns two values (the paginated array subsection, and an options hash), both of which must be stored as class variables. 

It has a :db_mode parameter which tells the gem to perform low level SQL queries, which are both faster, and take up less memory. This is only supported for MySQL databases at this point.

*An example of its use is as such:*
#### If you are using MySQL / MySQL2
```ruby
#app/controllers/users_controllers.rb
class UsersController < ApplicationController

  def index
    @users, @alphaParams = User.alpha_paginate(params[:letter], {db_mode: true, db_field: "name"})
  end
  
  ...
end
```

#### If you are not using MySQL
```ruby
#app/controllers/users_controllers.rb
class UsersController < ApplicationController

  def index
    @users, @alphaParams = User.all.alpha_paginate(params[:letter]){|user| user.name}
  end
  
  ...
end
```

### View
You need to call `alphabetical_paginate` that we just generated in the controller (i.e `<%= alphabetical_paginate @alphaParams %>`) in the view, whereever you would like to render the pagination selector div. You also **must wrap the content you want paginated in a div with id="pagination_table"**.

You can place as many `<%= alphabetical_paginate @alphaParams %>` as you wish on the page, if you want to render multiple pagination divs.

*An example is as such:*
```html
#app/controllers/users/index.html.erb

<%= alphabetical_paginate @alphaParams %>

<div id="pagination_table">
  <% User.all.each do |user| %>
    ...
  <% end %>
</div>
```

## Customization

### Options
The gem is highly customizable. The `alpha_paginate ` method takes a hash as an optional second parameter like such:

```ruby
#app/controllers/users_controllers.rb
class UsersController < ApplicationController

  def index
    @users, @alphaParams = User.all.alpha_paginate(params[:letter], {:enumerate => false}){|user| user.name}
  end
  
  ...
end
```

The available options are as follows:

Key | Value | Default |Description
--- | --- | --- | ---
`:db_mode` | `Boolean` | `false` | Whether to activate low level SQL that are faster and more memory efficient
`:db_field` | `String` | `id` | Required if `db_mode` is `true`. The field to paginate / sort by (on the same collection).
`:enumerate` | `Boolean` | `false` | Whether you want the number field collapsed (all numbers go into `0`) or separate (`0`, `1`, `2`...).
`:default_field` | `String` | `"a"` | Which field you want the page to default to on first load (`"0"`, `"a"`. `"*"`).
`:paginate_all` | `Boolean` | `false` | Whether you want empty fields to still render in pagination. If it's falsy and `db_mode` is thruty is will perform one more aggregation query: set it to true if performances matter.
`:include_all` | `Boolean` | `true` | Whether you want `all` selector to be included in the pagination.
`:numbers` | `Boolean` | `true` | Whether you want numbers to be included in the pagination at all, either collapsed, or expanded (depending on `:enumerate`).
`:others` | `Boolean` | `true` | Whether you want all other characters (non alphanumeric) to be included in the pagination at all.
`:pagination_class` | `String` | `"pagination-centered"` | All the classes you would like to add to the rendered pagination selector div (for CSS purposes).
`:js` | `Boolean` | `"true"` | If you want the javascript with page-rerendering to be enabled.
`:support_language` | `Symbol` | `:en` | If you want russian letters support set this value to `:ru` (only if `I18n.locale` in your application set to `:ru`).
`:bootstrap3` | `Boolean` | `false` | If you want to enable bootstrap 3 support

## Advanced Pagination

You can select a complex field to paginate by. Be careful, as this may be slow in large data sets. This only works if db_mode is disabled.

For instance, the following example paginates posts by the author's group's name (jumping across two tables).
It still returns the Post objects despite whatever field you use to paginate / sort it by (It still auto-sorts by the pagination field).
```ruby
#app/controllers/users_controllers.rb
class UsersController < ApplicationController

  def index
    @posts, @alphaParams = Post.all.alpha_paginate(params[:letter]) do |post|
      author = post.author
      group = author.group
    end
  end
  
  ...
end
```

Also you can paginate by any array generally, it doesn't have to be a collection.
```ruby
  @friends, @params = friends.alpha_paginate(params[:letter]){|x| x}
```

## Rails 3.0 and Lower

The gem makes use of the Asset Pipeline, introduced in Rails 3.1. It still works with lower versions of Rails, however, you need to copy the assets over manually.

Copy the contents of `vendor/assets/javascripts` of this repo into the `public/javascripts` of your app
and also copy the contents of `vendor/assets/images` of this repo into the `public/images` of your app.

Also, there is one line in vendor/assets/javascripts that needs to be changed for Rails 3.0 support. That is, renaming the image path:
```javascript
  var img = "<img src='/assets/aloader.gif' class='loading'/>";
  // RAILS 3.0 USERS -> Please delete the above line and uncomment the bottom line
  //var img = "<img src='/images/aloader.gif' class='loading'/>";
```

# Support

Please feel free to reach out and contact if you find the gem useful at all! Also, feel free to report / fix any bugs or add features.
