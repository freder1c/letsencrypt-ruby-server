# frozen_string_literal: true

module Application
  module Data
    class Account < Base
      attribute :id
      attribute :email
      attribute :encrypted_password
      attribute :reset_password_token
      attribute :reset_password_sent_at
      attribute :failed_attempts
      attribute :unlock_token
      attribute :locked_at
      attribute :locale
      attribute :key_id
      attribute :created_at

      def password=(password)
        self.encrypted_password = Helper::Password.encrypt(password)
      end

      def valid_password?(passw)
        Helper::Password.valid?(passw, encrypted_password)
      end

      def locked?
        locked_at.present?
      end

      def key=(key)
        raise Error::WrongAssignement unless key.is_a?(Data::Key)

        self.key_id = key.id
      end
    end
  end
end
