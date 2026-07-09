class AddSafetyFieldsAndReports < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :blocked, :boolean, null: false, default: false
    add_column :users, :blocked_at, :datetime

    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reportable_type, null: false
      t.bigint :reportable_id, null: false
      t.string :reason, null: false
      t.text :details
      t.string :status, null: false, default: "open"

      t.timestamps
    end

    add_index :reports, [ :reportable_type, :reportable_id ]
    add_index :reports, :status
  end
end
