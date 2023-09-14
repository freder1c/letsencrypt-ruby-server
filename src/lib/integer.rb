# frozen_string_literal: true

class Integer
  def minutes
    self * 60
  end

  def day
    self * 60 * 60 * 24
  end

  def days
    day
  end
end
