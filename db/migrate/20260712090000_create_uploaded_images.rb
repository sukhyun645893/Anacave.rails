class CreateUploadedImages < ActiveRecord::Migration[8.1]
  def change
    create_table :uploaded_images do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename, null: false
      t.string :content_type, null: false
      t.integer :byte_size, null: false
      t.binary :data, null: false

      t.timestamps
    end
  end
end
