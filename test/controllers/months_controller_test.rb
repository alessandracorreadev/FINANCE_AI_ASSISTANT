require "test_helper"

class MonthsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    sign_in @user
    @month = @user.months.create!(year: 2024, month: "January", overview: "Test overview")
  end

  test "should get index" do
    get months_url
    assert_response :success
  end

  test "should get new" do
    get new_month_url
    assert_response :success
  end

  test "should get edit" do
    get edit_month_url(@month)
    assert_response :success
  end

  test "should get show" do
    get month_url(@month)
    assert_response :success
  end
end
