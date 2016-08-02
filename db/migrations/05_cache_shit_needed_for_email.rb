Sequel.migration do
  change do
    retried = false
    begin
      add_column(:results, :cached_data, :hstore)
    rescue Exception => boom
      DB.execute("create extension hstore;")
      raise boom if retried
      retried = true
      retry
    end
  end
end
