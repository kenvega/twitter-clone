class CreateConversationsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :conversation

      t.timestamps
    end
  end
end
