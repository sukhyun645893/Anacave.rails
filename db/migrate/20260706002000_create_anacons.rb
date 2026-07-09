class CreateAnacons < ActiveRecord::Migration[8.0]
  def change
    create_table :anacons do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :downloads_count, null: false, default: 0

      t.timestamps
    end

    add_index :anacons, :created_at
  end
end
