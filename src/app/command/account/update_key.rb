# frozen_string_literal: true

module Application
  module Command
    module Account
      class UpdateKey < Base
        def call(params = {})
          params = Validator.validate(Validator::Account::UpdateKey, params)
          account.attributes = params
          validate_key(account.key_id) if account.changed[:key_id]
          Repository::Account.new.update(account)
        end

        private

        def validate_key(id)
          check_if_key_exists(id)
          check_if_key_is_used_for_any_order(id)
        end

        def check_if_key_exists(id)
          key = Repository::Key.new(account).find(id)
          raise Error::UnprocessableEntity, key_id: [{ error: :invalid, value: id }] if key.nil?
        end

        def check_if_key_is_used_for_any_order(key_id)
          orders = Repository::Order.new(account).all(key_id:, page: { size: 1 })
          raise Error::UnprocessableEntity, key_id: [{ error: :used_for_order, value: key_id }] if orders.any?
        end
      end
    end
  end
end
