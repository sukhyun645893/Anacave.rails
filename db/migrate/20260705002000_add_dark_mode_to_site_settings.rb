class AddDarkModeToSiteSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :site_settings, :dark_mode, :boolean, null: false, default: false
  end
end
