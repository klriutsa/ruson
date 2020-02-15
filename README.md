# Ruson

A Ruby serialization/deserialization library to convert Ruby Objects into JSON and back

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

### Basic

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

#### name

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

#### nilable

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

#### nested class

##### class

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

###### Primary classes

* Array
* Boolean
* Float
* Integer
* Time


post.json
```json
{
  "title": "Ruson",
  "items": ["orange", "apple"],
  "is_new": "true",
  "rate": "3.8",
  "view": "1234",
  "expired_at": 1575608299
}
```

```ruby
class Post < Ruson::Base
  field :title
  field :items, class: Array
  field :is_new, class: Boolean
  field :rate, class: Float
  field :view, class: Integer
  field :expired_at, class: Time
end

json = File.read('post.json')
post = Post.new(json)
post.items #=> ["orange", "apple"]
post.is_new #=> true
post.rate #=> 3.8
post.view #=> 1234
post.expired_at #=> 2019-12-06 04:58:19 +0000
```

##### each class

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

#### enum

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

#### to_json

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

#### to_hash

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

#### API json parser

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

### Persistence

Persistence will save the models as JSON file, with the model ID as filename, and model class name as parent folder so that a `User` model with ID `1` will be saved as `Users/1.json`.

You *must* define the `output_folder` before to be able to call `save` or `destroy`.

```ruby
Ruson.output_folder = './db/'
```

#### Creating new record

```ruby
class User < Ruson::Base
  field :first_name
  field :last_name
  field :email
  field :title
end

# Using new + save
guillaume = User.new(first_name: 'Guillaume', last_name: 'Briat', email: 'guillaume@kaamelott.fr')
guillaume.save # Creates the ./db/Users/1.json file

# Or using the create method
guillaume = User.create(first_name: 'Guillaume', last_name: 'Briat', email: 'guillaume@kaamelott.fr')

puts File.read('./db/Users/1.json')
{"first_name":"Guillaume","last_name":"Briat","email":"guillaume@kaamelott.fr"}
=> nil
```

#### Updating a record

```ruby
# Assigning a value + save
guillaume.title = 'Burgundians King'
guillaume.save # Updates the ./db/Users/1.json file

# Or using the update method
guillaume.update(title: 'Burgundians King')

puts File.read('./db/Users/1.json')
{"first_name":"Guillaume","last_name":"Briat","email":"guillaume@kaamelott.fr","title":"Burgundians King"}
=> nil
```

#### Destroying a record

```ruby
guillaume.destroy # Deletes the ./db/Users/1.json file

puts File.read('./db/Users/1.json')
Traceback (most recent call last):
       16: from /usr/local/bundle/gems/bundler-2.0.2/exe/bundle:30:in `block in <top (required)>'
       ...
        2: from (irb):26
        1: from (irb):26:in `read'
Errno::ENOENT (No such file or directory @ rb_sysopen - ./db/Users/1.json)
```

### Querying

Ruson allows you to query for existing records.

You *must* define the `output_folder` before to query records.

```ruby
Ruson.output_folder = './db/'
```

#### Find a record by ID

```ruby
User.find(1) # Searches for a ./db/Users/1.json file

# Searching a user which doesn't exist
User.find(1234) #=> nil
User.find!(1234) #=> raises Ruson::RecordNotFound
```

#### Find first record

```ruby
User.first # Loads the first ./db/Users/*.json file.

# Without existing User records
User.first #=> nil
User.first! #=> raises Ruson::RecordNotFound
```

#### Find a record by attributes

post.json

```json
{
  "title": "Ruson",
  "content": "Welcome!"
}
```

```ruby
Post.create(File.read('post.json'))
```

```ruby
Post.where(title: 'Ruson')
#=> [#<Post:0x000055bb2e907b78 @title="Ruson", @content="Welcome!", @id=1>]

Post.where(content: 'Wel')
#=> []

Post.where(content: 'Welcome!')
#=> [#<Post:0x000055bb2e907b78 @title="Ruson", @content="Welcome!", @id=1>]

Post.where(title: 'Ruson', content: 'Welcome!')
#=> [#<Post:0x000055bb2e907b78 @title="Ruson", @content="Welcome!", @id=1>]
```

## Development

### Without Docker

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### With Docker

```
$ docker build -t `whoami`/ruson .
```

In order to see the available Rake tasks:

```
$ docker --rm `whoami`/ruson
rake build            # Build ruson-1.2.0.gem into the pkg directory
rake clean            # Remove any temporary products
rake clobber          # Remove any generated files
rake install          # Build and install ruson-1.2.0.gem into system gems
rake install:local    # Build and install ruson-1.2.0.gem into system gems without network access
rake release[remote]  # Create tag v1.2.0 and build and push ruson-1.2.0.gem to rubygems.org
rake spec             # Run RSpec code examples
```
_`--rm` means delete the container after the command has ended._

In order to execute the tests:

```
$ docker run --rm -it --volume "$PWD":/gem/ `whoami`/ruson rake spec
```
_`--volume` is used to sync the files from your current folder into the container so that if you change a file, the modification is available in the container._

In the case you'd like to access the IRB console:

```
$ docker run --rm -it --volume "$PWD":/gem/ `whoami`/ruson irb
irb(main):001:0> require 'ruson'
=> true
irb(main):002:0>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klriutsa/ruson. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code Status

[![Build Status](https://travis-ci.org/klriutsa/ruson.svg?branch=master)](https://travis-ci.org/klriutsa/ruson)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruson project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruson/blob/master/CODE_OF_CONDUCT.md).
