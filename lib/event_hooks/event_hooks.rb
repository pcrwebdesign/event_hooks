require 'active_record'

module EventHooks
	def self.included(base) #:nodoc:
		#base.extend EventHooks::ClassMethods
		super
	end

	# prepend the hook to the event
	# event won't run unless hook returns a true-ish value
	def hook_before(event, hook)
		raise EventHooks::DoubleHook.new if instance_methods.include?("#{event}_without_before_hook".to_sym)

		alias_method "#{event}_without_before_hook".to_sym, event

		define_method "#{event}_with_before_hook".to_sym do |*args|
			send(hook) && send("#{event}_without_before_hook".to_sym, *args)
		end

		alias_method event, "#{event}_with_before_hook".to_sym
	end

	Class.send(:include, EventHooks)

	module ClassMethods
		# make sure hook_after method must be injected in subclasses 
		def inherited(klass)
			klass.send(:extend, EventHooks::ClassMethods)
		end

		def hook_after(event, hook)
			raise EventHooks::DoubleHook.new if instance_methods.include?("#{event}_without_after_hook".to_sym)

			alias_method "#{event}_without_after_hook".to_sym, event

			define_method "#{event}_with_after_hook".to_sym do |*args|
				ActiveRecord::Base.transaction do
					res = send("#{event}_without_after_hook".to_sym, *args)
					unless send(hook)
						raise ActiveRecord::Rollback, "After_hook #{hook} failed"
						return false
					end
					res
				end
			end

			alias_method event, "#{event}_with_after_hook".to_sym
		end
	end

	ActiveRecord::Base.send(:extend, EventHooks::ClassMethods)
end
