require "delayable/version"

module Delayable
  extend ActiveSupport::Concern

  class_methods do
    def delay(method_name, class_method: false, wait: nil, limits_concurrency: nil, queue: :default)
      job = const_set(delayable_job_name(method_name, class_method:),
                      delayable_job_class(method_name, class_method:, concurrency_limits: limits_concurrency, queue:))

      defined_wait = wait
      delayable_define_method(class_method:, method_name:) do |*arguments, **kwargs|
        wait = kwargs.key?(:wait) ? kwargs.delete(:wait) : defined_wait
        run_data = { current_attributes: Current.attributes, record: self }
        job.set(wait:).perform_later(run_data, *arguments, **kwargs)
      end
    end

    private

    def delayable_job_class(method_name, class_method: false, concurrency_limits: nil, queue: :default)
      klass = self
      Class.new(ApplicationJob) do
        queue_as queue

        limits_concurrency(**concurrency_limits) if concurrency_limits.is_a?(Hash)

        define_method(:perform) do |run_data = {}, *arguments, **kwargs|
          Current.set(run_data[:current_attributes] || {}) do
            (class_method ? klass : run_data[:record]).__send__(method_name, *arguments, **kwargs)
          end
        end
      end
    end

    def delayable_job_name(method_name, class_method: false)
      :"#{'Class' if class_method}#{method_name.to_s.camelize}Job"
    end

    def delayable_define_method(class_method:, method_name:, &block)
      define_method_type = class_method ? :define_singleton_method : :define_method
      public_send(define_method_type, "#{method_name}_later", &block)
    end
  end
end
