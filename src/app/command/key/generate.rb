# frozen_string_literal: true

module Application
  module Command
    module Key
      class Generate < Base
        def call(params = {})
          params = Validator.validate(Validator::Key::Generate, params)
          file = OpenSSL::PKey::RSA.new(params["size"] || 4096)
          key = Data::Key.new(id: Digest::SHA512.hexdigest(file.to_s), account:, file:)
          Repository::Key.new(account).create(key)
        end
      end
    end
  end
end
