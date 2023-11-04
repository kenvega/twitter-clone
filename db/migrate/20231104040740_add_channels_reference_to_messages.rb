class AddChannelsReferenceToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :channel, null: false, foreign_key: true
  end
end
