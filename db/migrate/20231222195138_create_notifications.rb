class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :notifier, null: false, foreign_key: { to_table: :users }
      t.references :notified, null: false, foreign_key: { to_table: :users }
      t.references :tweet, foreign_key: true
      t.string :action, null: false

      t.timestamps
    end
  end
end
