# Ruson

Json ORM for Ruby Object

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruson'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruson

## Usage

post.json
```json
{
  "title": "Ruson",
  "content": "Welcome!"
}
```

```ruby
require 'ruson'

class Post < Ruson::Base  
  field :title
  field :content
end

json = File.read('post.json')
post = Post.new(json)
post.title #=> 'Ruson'
post.content #=> 'Welcome!'
```

### name

post.json
```json
{
  "title": "Ruson",
  "post_url": "http://sample.com"
}
```

```ruby
require 'ruson'

class Post < Ruson::Base
  field :title
  field :url, name: 'post_url'
end

json = File.read('post.json')
post = Post.new(json)
post.url #=> 'http://sample.com'
```

### nilable

post.json
```json
{
  "title": "Ruson",
  "post_url": "http://sample.com"
}
```

```ruby
class Post < Ruson::Base
  field :title, nilable: false
  field :url, name: 'post_url'
end

json = File.read('post.json')
post = Post.new(json) #=> Ruson::NotNilException
```

### nested class

#### class

post.json
```json
{
  "title": "Ruson",
  "post_url": "http://sample.com",
  "picture": {
    "title": "nice picture",
    "url": "http://sample.com/picture.png"
  }
}
```

```ruby
require 'ruson'

class Post < Ruson::Base
  field :title
  field :picture, class: Picture
end

class Picture < Ruson::Base
  field :title
  field :url
end

json = File.read('post.json')
post = Post.new(json)
post.picture.url #=> 'http://sample.com/picture.png'
```

##### Primary classes

* Boolean
* Integer
* Float


post.json
```json
{
  "title": "Ruson",
  "is_new": "true",
  "view": "1234",
  "rate": "3.8"
}
```

```ruby
class Post < Ruson::Base
  field :title
  field :is_new, class: Boolean
  field :view, class: Integer
  field :rate, class: Float
end

json = File.read('post.json')
post = Post.new(json)
post.is_new #=> true
post.view #=> 1234
post.rate #=> 3.8
```

#### each class

post.json
```json
{
  "title": "Ruson",
  "tags": [
    {
      "name": "Ruby"
    },
    {
      "name": "Json"
    }
   ]
}
```

```ruby
require 'ruson'

class Post < Ruson::Base
  field :title
  field :tags, each_class: Tag
end

class Tag < Ruson::Base
  field :name
end

json = File.read('post.json')
post = Post.new(json)
post.tags.first.name #=> 'Ruby'
```

### enum

article.json
```json
{  
   "title":"Title",
   "status":"draft"
}
```

```ruby
class Article < Ruson::Base
  field :title
  enum status: { :draft, :published }
end

article = Article.new('article.json')

article.status #=> :draft
article.draft? #=> true

article.status = 'published'
article.status #=> :published

article.status = 'undefined'
  #=> undefined is not a valid status (ArgumentError)
```

### to_json

```ruby
class Post < Ruson::Base
  field :title
  field :url
end

json = File.read('post.json')
post = Post.new(json)
post.url = 'https://example.com/examples'

post.to_json #=> "{\"title\":\"Ruson\",\"url\":\"https://example.com/examples\"}"
```

### to_hash

```ruby
class Post < Ruson::Base
  field :title
  field :url
end

json = File.read('post.json')
post = Post.new(json)
post.url = 'https://example.com/examples'

post.to_hash #=> {title: "Ruson", url: "https://example.com/examples" }
```

### API json parser

```ruby
class Article < Ruson::Base
  field :title
  field :description
end

conn = Faraday::Connection.new(url: 'https://your.api/articles/1') do |faraday|
  faraday.request :url_encoded
  faraday.adapter Faraday.default_adapter
end

response = conn.get
article = Article.new(response.body)
article.title
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klriutsa/ruson. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code Status

[![Build Status](https://travis-ci.org/klriutsa/ruson.svg?branch=master)](https://travis-ci.org/klriutsa/ruson)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruson project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruson/blob/master/CODE_OF_CONDUCT.md).
