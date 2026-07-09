class AddUsernameToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :username, :string

    execute <<~SQL.squish
      UPDATE users
      SET username = COALESCE(NULLIF(regexp_replace(lower(split_part(COALESCE(email_address, ''), '@', 1)), '[^a-z0-9_]', '_', 'g'), ''), 'user' || id)
    SQL

    change_column_null :users, :username, false
    change_column_null :users, :email_address, true
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    change_column_null :users, :email_address, false
    remove_column :users, :username
  end
end
