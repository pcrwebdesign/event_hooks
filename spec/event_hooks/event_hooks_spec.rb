require 'spec_helper'

class StateMachine
	attr_accessor :ready, :submitted

	def initialize(ready=true)
		@ready = ready
		@submitted = false
	end

	def submit 
		puts "SUBMIT NOW"
		@submitted = true
	end

	def submission_preconditions
		@ready
	end

	hook_before :submit, :submission_preconditions
end

describe "any class" do
	class Sub; end

	it "responds to hook_before" do
		Sub.should respond_to(:hook_before)
	end
end

describe 'hook_before' do
	let(:sm) { StateMachine.new }

	it "calls the hook before sending the event" do
		sm.should_receive(:submission_preconditions)
		sm.submit
	end

	context "when precondition is met (hook returns true)" do
		it "allows the event to occur" do
			sm.should_receive(:submit_without_before_hook).and_call_original
			sm.submit
			sm.submitted.should be_true
		end
	end

	context "when precondition is not met (hook returns false)" do
		let(:sm) { StateMachine.new(false) }

		it "stops the event from happening" do
			sm.should_receive(:submit_without_before_hook).never
			sm.submit
			sm.submitted.should be_false
		end
	end

	context "when you try to add another before hook" do
		class StateMachine
			def another_hook
			end
		end

		it "raises a DoubleHook exception" do
			expect { StateMachine.send :hook_before, :submit, :another_hook }.
				to raise_exception(EventHooks::DoubleHook)
		end
	end
end
