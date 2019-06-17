class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
      
      t.string   :ip
      t.integer  :user_id
      t.string   :user_agent
      t.text     :object_changes
      t.integer  :transaction_id
    end
    add_index :versions, [:item_type, :item_id]
    add_index :versions, [:transaction_id]
  end
end
