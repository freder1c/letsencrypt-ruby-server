# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:challenges) do
      column :id, "uuid", default: Sequel::LiteralString.new("gen_random_uuid()"), null: false
      column :order_id, "uuid", null: false
      column :url, "text", null: false
      column :token, "text", null: false
      column :status, "text", null: false
      column :type, "text", null: false
      column :content, "jsonb", null: false
      column :created_at, "timestamp(6) without time zone", null: false

      primary_key [:id]
    end

    alter_table(:orders) do
      drop_column :challenge_type
    end
  end

  down do
    drop_table(:challenges)

    alter_table(:orders) do
      add_column :challenge_type, "text", null: false
    end
  end
end
