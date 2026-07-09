class AddApprovalStatusToAnacons < ActiveRecord::Migration[8.0]
  def change
    add_column :anacons, :status, :string, null: false, default: "pending"
    add_reference :anacons, :approved_by, foreign_key: { to_table: :users }
    add_column :anacons, :approved_at, :datetime
    add_index :anacons, :status

    reversible do |dir|
      dir.up { Anacon.update_all(status: "approved") }
    end
  end
end
