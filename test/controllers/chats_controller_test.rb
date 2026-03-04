require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "chat@example.com", password: "password123", password_confirmation: "password123")
    sign_in @user
    @month = @user.months.create!(year: 2024, month: "January", overview: "Test")
  end

  test "should get chat show" do
    get month_chat_url(@month)
    assert_response :success
  end
end
