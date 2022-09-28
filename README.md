# ChankoAb

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chanko_ab'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chanko_ab

## Usage
```ruby
# Define logging code and identifier
# e.g.
ChankoAb.logging do |name, attrs|
  Rails.logger.debug(name)
end

ChankoAb.identifier digit: 1, radix: 10, extractor: -> (ctx) do
  ctx.cookies[:identifier][-1]
end
```

```ruby
# And then, prepare ab test chanko unit.
module MySplitTest
  include Chanko::Unit
  include ChankoAb

  split_test.cohort name: :default, attributes: {}
  split_test.cohort name: :pattern1, attributes: { partial: "partian1" }

  split_test.log_template name: 'show' template: 'my_split_test.[name]'

  split_test.define(:new_text, scope: :view) do |cohort|
    cohort.log('show')
    context.instance_eval do
      case cohort.name
      when 'default'
        run_default
      else
        render cohort.attributes[:partial]
      end
    end
  end
end
```

### Switch using identifier
```ruby
module MySplitTest
  ...

  split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) do
    ctx.cookies&.then do |cookies|
     cookies.[:identifier][-1]
  end
  ...
end
```

### Use HexIdentifier if identifier is composed by hex.
```ruby
module HexMySplitTest
  ...
  split_test.identifier digit: 1, radix: 16, extractor: -> (ctx) do
    ctx.cookies[:hex_identifier][-1]
  end
  ...
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eudoxa/chanko_ab.
