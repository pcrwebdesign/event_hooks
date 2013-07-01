# EventHooks

EventHooks enhances Ruby classes to allow adding pre-conditions to method calls (events).
If the pre-conditions method returns false the event method will not run. It can be used on ActiveRecord subclasses to validate some conditions only when a certain event occurs. 

## Installation

Add this line to your application's Gemfile:

    gem 'event_hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_hooks

## Usage

Within the class that you want to hook the pre-condition to simply write:
```ruby
  hook_before :event, :hook
```

where:
* event is the name of a method that you must define prior to the hook_before.
* hook is the name of a method that will be run before the call to event. 

```ruby
class AnyClass
	def submit
	  # do something
	end
	hook_before :submit, :submit_preconditions

  def submit_preconditions
	  am_i_ready?
  end
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
