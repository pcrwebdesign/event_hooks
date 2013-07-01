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
end
