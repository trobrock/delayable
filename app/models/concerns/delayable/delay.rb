# frozen_string_literal: true

module Delayable
  module Delay
    extend ActiveSupport::Concern

    class_methods do
      def delay(method_name, wait: nil)
        defined_wait = wait
        if method_name.end_with?('!')
          new_method_name = "#{method_name[0..-2]}_later!"
        else
          new_method_name = "#{method_name}_later"
        end

        # rubocop:disable Lint/ShadowingOuterLocalVariable
        define_method(:"#{new_method_name}") do |wait: defined_wait|
          Delayable::Job.set(wait:).perform_later(self, method_name)
        end
        # rubocop:enable Lint/ShadowingOuterLocalVariable
      end
    end
  end
end
