# frozen_string_literal: true

module Application
  module Command
    module Key
      class Upload < Base
        def call(params = {})
          file_params = params[:file]
          raise Error::UnprocessableEntity, file: [{ error: :blank }] unless file_params || file_params[:tempfile]

          key = build_key(file_params)
          repository.create(key)
        rescue OpenSSL::PKey::RSAError => _exception
          raise Error::UnprocessableEntity, file: [{ error: :invalid_format }]
        end

        private

        def repository
          @repository ||= Repository::Key.new(account)
        end

        def build_key(file_params)
          file = OpenSSL::PKey::RSA.new(file_params[:tempfile].read)
          key = Data::Key.new(id: Digest::SHA512.hexdigest(file.to_s), account:, file:)

          # Check if this key was not already generated or uploaded to current account
          return key if repository.find(key.id, account_id: account.id).nil?

          raise Error::UnprocessableEntity, file: [{ error: :already_uploaded }]
        end
      end
    end
  end
end
