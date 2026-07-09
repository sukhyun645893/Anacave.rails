class CreateUserAnacons < ActiveRecord::Migration[8.0]
  def change
    create_table :user_anacons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :anacon, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_anacons, [ :user_id, :anacon_id ], unique: true
  end
end
