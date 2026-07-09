class CreateSiteSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :site_settings do |t|
      t.string :name, null: false, default: "default"
      t.timestamps
    end

    add_index :site_settings, :name, unique: true
  end
end
