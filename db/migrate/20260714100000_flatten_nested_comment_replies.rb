class FlattenNestedCommentReplies < ActiveRecord::Migration[8.0]
  class MigrationComment < ActiveRecord::Base
    self.table_name = "comments"

    belongs_to :parent, class_name: "FlattenNestedCommentReplies::MigrationComment", optional: true
  end

  def up
    loop do
      changed_count = 0

      MigrationComment.where.not(parent_id: nil).find_each do |comment|
        next if comment.parent&.parent_id.blank?

        comment.update_columns(parent_id: comment.parent.parent_id)
        changed_count += 1
      end

      break if changed_count.zero?
    end
  end

  def down
  end
end
