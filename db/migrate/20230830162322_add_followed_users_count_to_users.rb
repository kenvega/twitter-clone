class AddFollowedUsersCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :followed_users_count, :integer, null: false, default: 0
  end
end
