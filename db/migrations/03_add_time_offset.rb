Sequel.migration do
  change do
    alter_table(:people) do
      add_column :time_offset, :smallint
    end
  end
end
