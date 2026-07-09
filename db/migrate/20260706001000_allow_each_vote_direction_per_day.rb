class AllowEachVoteDirectionPerDay < ActiveRecord::Migration[8.0]
  def change
    remove_index :post_votes, [ :post_id, :user_id, :voted_on ]
    add_index :post_votes, [ :post_id, :user_id, :voted_on, :value ], unique: true
  end
end
