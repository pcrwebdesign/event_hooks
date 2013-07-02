# EventHooks

EventHooks enhances 
* Ruby classes to allow adding pre-conditions to method calls (events).
* ActiveRecord::Base subclasses to allow adding post-conditions to methods calls.

If the pre-conditions method returns false the event method will not run. It can be used on ActiveRecord subclasses to validate some conditions only when a certain event occurs. 

If the post-conditions method returns false the database operations triggered by the event will be rolled back. Again, it can be used to validate some conditions after a certain event occurs. 

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

or to hook a post-condition
```ruby
	hook_after :event, :hook
```

An example: 

```ruby
class AnyClass
	def submit
		# do something
	end
	hook_before :submit, :submit_preconditions
	hook_after :submit, :submit_postconditions

  	def submit_preconditions
		am_i_ready?
  	end

	def submit_postconditions
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
