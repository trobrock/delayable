# frozen_string_literal: true

module Delayable
  class Job < ::ApplicationJob
    queue_as :default

    def perform(record, method)
      record.__send__(method)
    end
  end
end
