# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:orders) do
      column :id, "uuid", default: Sequel::LiteralString.new("gen_random_uuid()"), null: false
      column :account_id, "text", null: false
      column :status, "text"
      column :created_at, "timestamp(6) without time zone", null: false

      primary_key [:id]

      index [:account_id]
    end
  end
end
