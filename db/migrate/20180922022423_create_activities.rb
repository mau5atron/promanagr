class CreateActivities < ActiveRecord::Migration[5.2]
  def self.up
    create_table :activities do |t|
    	t.string :trackable_type
    	t.integer :trackable_id
    	t.string :owner_type
    	t.integer :owner_id
    	t.string :key
    	t.text :parameters
    	t.string :recipient_type 
    	t.integer :recipient_id
    	t.timestamps null: false
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:owner_id, :owner_type]
    add_index :activities, [:recipient_id, :recipient_type]
  end

  def self.down
  	drop_table :activities
  end
end
