# Emigrant

This lib works as a fail-safe progress aware white-box framework to assist
external database migrations into a Rails app. The framework provides
specific infra-structure to allow the developer to create only the ActiveRecord
interfaces with the proper migration implementation to migrate the external
entities into your Rails app entities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emigrant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emigrant

## Usage

### Development dependencies

Emigrant depends on sqlite3 to run its tests. So you must have sqlite3.h
installed somehow:
```
port install sqlite3 +universal
OR
yum install sqlite-devel
OR
apt-get install libsqlite3-dev
````

### Configuration

Before starting any development, you must configure _emigrant_. Here is a
sample _emigrant_ configuration:

```ruby
# config/initializers/emigrant.rb

require 'emigrant'

Emigrant.configure({
  database: {
    host:     'earth.federation.org',
    adapter:  'postgresql',
    encoding: 'unicode',
    database: 'uss_enterprise',
    username: 'picard',
    password: 'b4teta2omega9'
  },
  entities_folder: File.join(Rails.root, 'app', 'models', 'emigrant')
})
```

The *database* option defines the connection parameters for your external
database. The *entities_folder* option defines the folder where you will
implement the entities AR interfaces.

### Interface Entities

TODO

## Contributing

1. Fork it ( https://gitlab.com/diguliu/emigrant/fork/new )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Developers

* Rodrigo Souto (diguliu)

## License

Copyright (c) 2015 Rodrigo Souto, released under the [Gpl
v3](http://www.gnu.org/licenses/gpl-3.0-standalone.html).
