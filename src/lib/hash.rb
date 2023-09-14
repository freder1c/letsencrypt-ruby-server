# frozen_string_literal: true

class Hash
  def self.symbolize_keys(hash)
    hash.to_h do |key, value|
      value = Hash.symbolize_keys(value) if value.is_a?(Hash)
      [key.to_sym, value]
    end
  end

  def symbolize_keys
    Hash.symbolize_keys(self)
  end
end
