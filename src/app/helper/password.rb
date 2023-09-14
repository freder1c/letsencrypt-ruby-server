require "digest"

module Application
  module Helper
    module Password
      STRETCHES = 10
      PEPPER = ENV.fetch("PASSWORD_PEPPER")
      # TODO: Add some salt to the pepper :)

      def self.encrypt(password)
        digest = PEPPER
        STRETCHES.times { digest = secure_digest(digest, password, PEPPER) }
        digest
      end

      def self.valid?(password, encrypted_password)
        encrypt(password) == encrypted_password
      end

      def self.secure_digest(*tokens)
        ::Digest::SHA512.hexdigest("--" << tokens.flatten.join("--") << "--")
      end
    end
  end
end
