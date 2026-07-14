class CreateSecurityEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :security_events do |t|
      t.references :user, null: true, foreign_key: true
      t.references :record, polymorphic: true, null: true
      t.string :action, null: false
      t.string :ip_address
      t.string :ip_address_hash, null: false
      t.string :user_agent
      t.datetime :retained_until, null: false

      t.timestamps
    end

    add_index :security_events, :action
    add_index :security_events, :created_at
    add_index :security_events, :retained_until
    add_index :security_events, :ip_address_hash
  end
end
