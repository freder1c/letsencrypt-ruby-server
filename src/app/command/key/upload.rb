# frozen_string_literal: true

module Application
  module Command
    module Key
      class Upload < Base
        def call(params = {})
          file_params = params[:file]
          raise Error::UnprocessableEntity, file: [{ error: :blank }] unless file_params || file_params[:tempfile]

          file = OpenSSL::PKey::RSA.new(file_params[:tempfile].read)
          key = Data::Key.new(id: Digest::SHA512.hexdigest(file.to_s), account:, file:)
          Repository::Key.new(account).create(key)
        rescue OpenSSL::PKey::RSAError => exception
          raise Error::UnprocessableEntity, file: [{ error: :invalid_format }]
        end
      end
    end
  end
end
