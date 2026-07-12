class AddParentToComments < ActiveRecord::Migration[8.1]
  def change
    add_reference :comments, :parent, null: true, foreign_key: { to_table: :comments }
    add_index :comments, [ :post_id, :parent_id, :created_at ]
  end
end
