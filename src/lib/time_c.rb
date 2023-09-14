# frozen_string_literal: true

class Time
  def self.current
    now.utc
  end
end
