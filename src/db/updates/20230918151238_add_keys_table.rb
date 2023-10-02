# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:keys) do
      column :id, "text", null: false
      column :account_id, "uuid", null: false
      column :created_at, "timestamp(6) without time zone", null: false

      primary_key [:id]

      index %i[id account_id], unique: true
    end

    alter_table(:orders) do
      add_column :key_id, "text", null: false
    end
  end
end
