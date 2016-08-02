Sequel.migration do
  up do
    create_table(:people) do
      primary_key :id
      String :name, null: false
      String :email, null: false
    end

    create_table(:subscriptions) do
      primary_key :id
      foreign_key :person_id, :people
      foreign_key :search_id, :searches
    end

    create_table(:notifications_results) do
      primary_key :id
      foreign_key :notification_id, :notifications
      foreign_key :result_id, :results
    end

    alter_table(:notifications) do
      #rename_column(:subscriber_id, :person_id)
      drop_column(:subscriber_id)
      add_foreign_key(:person_id, :people)
    end

    #alter_table(:subscribers) do
      #drop_column(:name)
      #drop_column(:email)
      #foreign_key(:person_id, :people)
    #end
    drop_table(:subscribers)
  end

  down do
    drop_table(:people, cascade: true)
    drop_table(:subscriptions, cascade: true)
    drop_table(:notifications_results, cascade: true)

    create_table(:subscribers) do
      primary_key :id
      foreign_key :search_id, :searches

      String :name, null: false
      String :email, null: false
    end

    alter_table(:notifications) do
      #rename_column(:subscriber_id, :person_id)
      drop_column(:person_id)
      add_foreign_key(:subscriber_id, :subscribers)
    end
  end
end
