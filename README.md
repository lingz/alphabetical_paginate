# AlphabeticalPaginate

A lightweight and highly customizable pagination gem for Ruby on Rails that generates alphabetic pagination categories from collection arrays. It allows you to select the field you want to paginate on. 

By default, it works with [Bootstrap Pagination](http://twitter.github.io/bootstrap/components.html#pagination) CSS and it is also fully compatible with the [will_paginate](https://github.com/mislav/will_paginate) in case you want to use both. 

AlphabeticalPaginate incorporates efficient partial page rerendering techniques and loading animations.

Some code was inspired by [will_paginate](https://github.com/mislav/will_paginate)


## Installation

Add this line to your application's Gemfile:

    gem 'alphabetical_paginate'

And then execute:

    $ bundle install

## Basic Setup

Basic Pagination is as simple as adding a few lines to the controller and the view.

### Controller
You simply need to call alpha_paginate on the desired table (i.e. `User.all.alpha_paginate`). This method takes two parameters, the first always being `params[:letter]` and the second being an optional options hash. 

Also, it takes a block in which you can specify the field you wish to paginate by (it can even be in another table). It returns the paginated subset of the collection, sorted by the pagination field. The method returns two values (the paginated array subsection, and an options hash), both of which must be stored as class variables. 

An example of its use is as such:
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
You need to call `alphabetical_paginate` that we just generated in the controller (i.e `<%= alphabetical_paginate @alphaParams %>`) in the view, whereever you would like to render the pagination selector div. 

You also **must wrap the content you want paginated in a div with id="pagination_table"**.

You can place as many `<%= alphabetical_paginate @alphaParams =>` as you wish on the page, if you want to render multiple pagination divs.

An example is like such:
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
:enumerate | Boolean | false | Whether you want the number field collapsed (all numbers go into 0) or separate (0, 1, 2, 3 .. 9).
:default_field | String | "a" | Which field you want the page to default to on first load ("0", "a". "*").
:paginate_all | Boolean | false | Whether you want empty fields to still render in pagination.
:numbers | Boolean | true | Whether you want numbers to be included in the pagination at all, either collapsed, or expanded (depending on :enumerate).
:others | Boolean | true | Whether you want all other characters (non alphanumeric) to be included in the pagination at all.
:pagination_class | String | "pagination-centered" | All the classes you would like to add to the rendered pagination selector div (for CSS purposes).

## Advanced Pagination

You can select a complex field to paginate by. Be careful, as this may be slow in large data sets.

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


## Support

Please feel free to reach out and contact if you find the gem useful at all! Also, feel free to report / fix any bugs or add features.
