
Sequel.migration do
  up do
    create_table(:searches) do
      primary_key :id
      String :name, null: false
      String :params
      String :search_url
    end

    create_table(:subscribers) do
      primary_key :id
      foreign_key :search_id, :searches

      String :name, null: false
      String :email, null: false
    end

    create_table(:notifications) do
      primary_key :id

      foreign_key :subscriber_id, :subscribers

      FalseClass :notified
    end

    create_table(:results) do
      primary_key :id
      foreign_key :search_id, :searches
      foreign_key :notification_id, :notifications

      String :url, null: false
      String :post_id
      String :repost_of
      String :hash
    end

  end

  down do
    drop_table(:results, cascade: true)
    drop_table(:subscribers, cascade: true)
    drop_table(:notifications, cascade: true)
    drop_table(:searches, cascade: true)
  end
end

