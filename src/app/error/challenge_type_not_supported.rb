# frozen_string_literal: true

module Application
  module Error
    class ChallengeTypeNotSupported < StandardError
      def initialize(type:)
        super("Challenge type \"#{type}\" is not supported.")
      end
    end
  end
end
