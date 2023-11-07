# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:orders) do
      add_column :identifier, "text", null: false
      add_column :challenge_type, "text", null: false
    end
  end
end
