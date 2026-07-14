require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @chapter = chapters(:free)
  end

  test "should get index" do
    get chapter_url(@chapter)
    assert_response :success
  end

  test "should get new" do
    sign_in_as @post.user

    get new_chapter_post_url(@chapter)
    assert_response :success
    assert_select "input[type=submit][value='글쓰기 완료']", 1
  end

  test "should create post" do
    sign_in_as @post.user

    assert_difference("Post.count") do
      assert_difference("SecurityEvent.count") do
      post chapter_posts_url(@chapter), params: { post: { body: @post.body, title: @post.title, chapter_id: @chapter.id } }
      end
    end

    assert_redirected_to post_url(Post.last)
    assert_equal "post.create", SecurityEvent.last.action
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as @post.user

    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    sign_in_as @post.user

    patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    sign_in_as @post.user

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to chapter_url(@post.chapter)
  end
end
