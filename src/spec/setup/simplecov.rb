# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_group("Error", File.join("app", "error"))
  add_group("Data", File.join("app", "data"))
  add_group("Command", File.join("app", "command"))
  add_group("Validator", File.join("app", "validator"))

  add_filter("spec")
end
