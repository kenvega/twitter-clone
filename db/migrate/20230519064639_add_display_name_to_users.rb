class AddDisplayNameToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :display_name, :string

    # if you already have users and want to make sure display_name has a value for them
    query = <<~SQL
      update users
      set display_name = username
      where display_name is null
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

  def down
    remove_column :users, :display_name
  end
end
