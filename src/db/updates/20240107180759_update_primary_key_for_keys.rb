# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:keys) do
      drop_constraint :keys_pkey
      add_primary_key %i[id account_id], name: "keys_pkey"
    end
  end
end
