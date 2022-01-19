class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :number, null: false  # unique number auto increment for specific chat
      t.text :message, null: false  # the message body of chat
      t.belongs_to :chat, null: false, foreign_key: true  # relation for chat

      t.timestamps
    end

    add_index :messages, [:chat_id, :number], unique: true  # unique index of chat and number
  end
end
