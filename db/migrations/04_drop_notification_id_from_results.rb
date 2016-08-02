Sequel.migration do
  change do
    alter_table(:results) do
      drop_column(:notification_id)
    end
  end
end
