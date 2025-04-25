require 'test_helper'
require 'active_model'
require 'active_job'
require 'active_support/current_attributes'

GlobalID.app = 'delayable'
ActiveJob::Base.logger = nil
ActiveJob::Base.queue_adapter = :test

RESPONSES = [] # rubocop:disable Style/MutableConstant

class ApplicationJob < ActiveJob::Base
end

class Current < ActiveSupport::CurrentAttributes
  attribute :user
end

class ExampleDelayable
  include GlobalID::Identification
  include Delayable

  def self.find(*_args)
    new
  end

  def id
    123
  end

  def my_method
    RESPONSES << 'my_method'
  end
  delay :my_method

  def current_test
    RESPONSES << ['current_test', Current.user]
  end
  delay :current_test

  def my_method!
    RESPONSES << 'my_method!'
  end
  delay :my_method!
end

class DelayableTest < Minitest::Test
  include ActiveJob::TestHelper

  # required for perform_enqueued_jobs
  def tagged_logger
    ActiveSupport::TaggedLogging.new(Logger.new(nil))
  end

  def setup
    RESPONSES.clear
  end

  def test_it_defines_a_delayed_method
    assert_equal true, ExampleDelayable.new.respond_to?(:my_method_later)
  end

  def test_it_enqueues_a_job
    assert_enqueued_jobs 1, only: 'ExampleDelayable::MyMethodJob'.constantize, queue: :default do
      ExampleDelayable.new.my_method_later
    end
  end

  def test_it_calls_the_method
    perform_enqueued_jobs do
      ExampleDelayable.new.my_method_later
    end

    assert_equal 'my_method', RESPONSES.first
  end

  def test_current_attributes_are_passed_to_job
    Current.user = :some_user

    perform_enqueued_jobs do
      ExampleDelayable.new.current_test_later
    end

    assert_equal ['current_test', :some_user], RESPONSES.first
  end

  def test_it_enqueues_with_bang_methods
    assert_enqueued_jobs 1, only: 'ExampleDelayable::MyMethodBangJob'.constantize, queue: :default do
      ExampleDelayable.new.my_method_later!
    end
  end

  def test_it_calls_the_bang_method
    perform_enqueued_jobs do
      ExampleDelayable.new.my_method_later!
    end

    assert_equal 'my_method!', RESPONSES.first
  end
end
