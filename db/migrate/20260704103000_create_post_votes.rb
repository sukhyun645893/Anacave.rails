class CreatePostVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :post_votes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value, null: false
      t.date :voted_on, null: false

      t.timestamps
    end

    add_index :post_votes, [ :post_id, :user_id, :voted_on ], unique: true
  end
end
