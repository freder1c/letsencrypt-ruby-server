# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:keys) do
      column :id, "uuid", default: Sequel::LiteralString.new("gen_random_uuid()"), null: false
      column :account_id, "text", null: false
      column :file_path, "text", null: false
      column :hash, "text", null: false
      column :created_at, "timestamp(6) without time zone", null: false

      primary_key [:id]

      index [:account_id]
    end

    alter_table(:orders) do
      add_column :key_id, "uuid", null: false
    end
  end
end
