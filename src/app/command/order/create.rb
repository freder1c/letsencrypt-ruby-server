# frozen_string_literal: true

module Application
  module Command
    module Order
      class Create < Base
        def call(params = {})
          params = Validator.validate(Validator::Order::Create, params)
          key = find_key(params[:key_id])
          order = Data::Order.new(account:, key:)
          Repository::Order.new(account).create(order)
        end

        private

        def find_key(id)
          Key::Find.new(account).call(id)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, id: [{ error: :invalid, value: id }]
        end
      end
    end
  end
end
