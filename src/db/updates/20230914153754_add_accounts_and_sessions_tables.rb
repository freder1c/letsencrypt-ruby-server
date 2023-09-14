# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:accounts) do
      column :id, "uuid", default: Sequel::LiteralString.new("gen_random_uuid()"), null: false
      column :email, "text", null: false
      column :encrypted_password, "text", null: false
      column :reset_password_token, "text"
      column :reset_password_sent_at, "timestamp(6) without time zone"
      column :failed_attempts, "integer", default: 0, null: false
      column :unlock_token, "text"
      column :locked_at, "timestamp(6) without time zone"
      column :locale, "text"
      column :created_at, "timestamp(6) without time zone", null: false

      primary_key [:id]

      index [:email], unique: true
    end

    create_table(:sessions) do
      column :id, "uuid", default: Sequel::LiteralString.new("gen_random_uuid()"), null: false
      column :account_id, "uuid", null: false
      column :created_at, "timestamp(6) without time zone", null: false
      column :expires_at, "timestamp(6) without time zone"

      primary_key [:id]

      index [:account_id]
    end
  end
end
