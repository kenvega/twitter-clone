class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :tweet, null: false, foreign_key: true
      t.references :mentioned_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
