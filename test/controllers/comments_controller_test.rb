require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    sign_in_as @comment.user
  end

  test "should get index" do
    get comments_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post post_comments_url(@comment.post), params: { comment: { body: @comment.body } }
    end

    assert_redirected_to post_url(@comment.post)
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment), params: { comment: { body: @comment.body, post_id: @comment.post_id } }
    assert_redirected_to post_url(@comment.post)
  end

  test "should destroy comment" do
    post = @comment.post

    assert_difference("Comment.count", -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to post_url(post)
  end
end
