# frozen_string_literal: true

require "dry-schema"

module Application
  module Validator
    module_function

    def validate(validator, params)
      result = validator.call(params)
      return result.to_h unless result.errors.any?

      raise Error::UnprocessableEntity, map_error(result.errors.to_h)
    end

    def map_error(hash)
      hash.each do |attr, err|
        if err.is_a?(Hash)
          map_error(err)
        else
          hash[attr].each_with_index { |message, index| hash[attr][index] = resolve_error_string(message) }
        end
      end
    end

    def resolve_error_string(message)
      {
        error: error_message_to_key(message)
      }
    end

    def error_message_to_key(message)
      {
        "must be filled" => "blank",
        "is missing" => "blank",
        "must be a date" => "invalid_date",
        "must be a time" => "invalid_time",
        "must be boolean" => "invalid_type",
        "must be an integer" => "invalid_type",
        "is in invalid format" => "invalid_format"
      }[message]
    end

    def uuid_format
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    end

    def password_format
      /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*]).{6,}$/
    end

    def email_format
      /^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/
    end
  end
end
