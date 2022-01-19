class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name, null: false   # application name
      t.string :access_token, null: false  # application access token that generated from the system and will use it to call any api
      t.integer :chats_count, null: false,default: 0  #number of created chats

      t.timestamps
    end
  end
end
