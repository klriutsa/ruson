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
    def fields
      field :title
      field :content
    end
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
  def fields
    field :title
    field :url, name: 'post_url'
  end
end

json = File.read('post.json')
post = Post.new(json)
post.url #=> 'http://sample.com'
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
  def fields
    field :title
    field :picture, class: Picture
  end
end

class Picture < Ruson::Base
  def fields
    field :title
    field :url
  end
end

json = File.read('post.json')
post = Post.new(json)
post.picture.url #=> 'http://sample.com/picture.png'
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
  def fields
    field :title
    field :tags, each_class: Tag
  end
end

class Tag < Ruson::Base
  def fields
    field :name
  end
end

json = File.read('post.json')
post = Post.new(json)
post.tags.first.name #=> 'Ruby'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruson. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruson project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruson/blob/master/CODE_OF_CONDUCT.md).
