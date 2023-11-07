# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:orders) do
      add_column :url, "text", null: false
      add_column :finalize_url, "text", null: false
      add_column :certificate_url, "text"
      add_column :expires_at, "timestamp(6) without time zone", null: false
      add_column :finalized_at, "timestamp(6) without time zone"
    end
  end
end
