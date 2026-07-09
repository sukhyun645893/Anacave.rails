require "test_helper"

class PostVotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:one)
    sign_in_as @user
  end

  test "should upvote a post" do
    assert_difference("PostVote.count") do
      post post_post_votes_url(@post, value: "up")
    end

    assert_redirected_to post_url(@post)
    assert_equal 1, @post.post_votes.last.value
  end

  test "should downvote a post" do
    assert_difference("PostVote.count") do
      post post_post_votes_url(@post, value: "down")
    end

    assert_redirected_to post_url(@post)
    assert_equal(-1, @post.post_votes.last.value)
  end

  test "should allow one upvote and one downvote per day on a post" do
    post post_post_votes_url(@post, value: "up")

    assert_difference("PostVote.count") do
      post post_post_votes_url(@post, value: "down")
    end

    assert_redirected_to post_url(@post)
  end

  test "should only allow the same vote direction once per day" do
    post post_post_votes_url(@post, value: "up")

    assert_no_difference("PostVote.count") do
      post post_post_votes_url(@post, value: "up")
    end

    assert_redirected_to post_url(@post)
  end
end
