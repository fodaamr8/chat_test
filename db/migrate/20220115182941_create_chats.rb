class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.integer :number, null: false  # unique number auto increment for specific application
      t.belongs_to :app, null: false, foreign_key: true  # relation for application
      t.integer :messages_count, null: false,default: 0  # number of created messages
      t.integer :next_message_number, null: false,default: 0  # last number on messages will be created to handle queue

      t.timestamps
    end

    add_index :chats, [:app_id, :number], unique: true  # unique index of application and number
  end
end
