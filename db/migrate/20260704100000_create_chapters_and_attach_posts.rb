class CreateChaptersAndAttachPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :chapters do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end

    add_index :chapters, :slug, unique: true
    add_reference :posts, :chapter, foreign_key: true
  end
end
