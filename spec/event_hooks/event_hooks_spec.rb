require 'active_record'
require 'logger'
require 'spec_helper'

load_schema

class StateMachine
	attr_accessor :ready, :submitted

	def initialize(ready=true)
		@ready = ready
		@submitted = false
	end

	def submit 
		@submitted = true
	end

	def submission_preconditions
		@ready
	end

	hook_before :submit, :submission_preconditions
end

describe "any class" do
	class Bar; end

	it "responds to hook_before" do
		Bar.should respond_to(:hook_before)
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

		context "when you add the same hook to another event" do
			it "works" 
		end

		context "when you try to add another before hook to the same event" do
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
end

describe "ActiveRecord::Base" do
	it "responds to hook_after" do
		ActiveRecord::Base.should respond_to(:hook_after)
	end
end

describe "any ActiveRecord::Base subclass" do
	class Foo < ActiveRecord::Base
		attr_accessor :ready

		after_initialize do |object|
			object.ready = true
		end

		def submit
			save
			"SUBMITTED"
		end

		def submission_postconditions
			@ready
		end

		hook_after :submit, :submission_postconditions
	end

	it "responds to hook_after" do
		Foo.should respond_to(:hook_after)
	end

	describe "hook_after" do
		let(:foo) { Foo.new }

		it "calls the hook after sending the event" do
			foo.should_receive(:submit_without_after_hook).ordered
			foo.should_receive(:submission_postconditions).ordered
			foo.submit
		end

		context "when postcondition is met (hook returns true)" do
			it "returns the original return value of the event" do
				foo.submit.should == "SUBMITTED"
			end

			context "when event involves database changes" do
				it "changes the record" do
					foo.submit
					foo.should be_persisted
				end
			end
		end

		context" when postcondition is not met (hook returns false)" do
			before { foo.ready = false }

			it "returns false" do
				foo.submit.should be_false
			end

			context "when event involves database changes" do
				it "does not change the foo record" do
					foo.submit
					foo.should_not be_persisted
				end
			end
		end

		context "when you try to add the same hook to another event" do
			it "works"
		end

		context "when you try to add another after hook to the same event" do
			class Foo
				def another_hook
				end
			end

			it "raises a DoubleHook exception" do
				expect { Foo.send :hook_after, :submit, :another_hook }.
						to raise_exception(EventHooks::DoubleHook)
			end
		end
	end
end
