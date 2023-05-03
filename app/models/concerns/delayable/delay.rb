# frozen_string_literal: true

module Delayable
  module Delay
    extend ActiveSupport::Concern

    class_methods do
      def delay(method_name, wait: nil)
        defined_wait = wait

        # rubocop:disable Lint/ShadowingOuterLocalVariable
        define_method(:"#{method_name}_later") do |wait: defined_wait|
          Delayable::Job.set(wait:).perform_later(self, method_name)
        end
        # rubocop:enable Lint/ShadowingOuterLocalVariable
      end
    end
  end
end
