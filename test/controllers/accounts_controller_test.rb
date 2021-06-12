require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "should return error response if account does not exist" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    get "/accounts/1"
    assert_response :not_found
  end

  test "should return success response if account does exist and balance initialized to default zero" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    acc = Account.create(user: @user)
    get "/accounts/#{acc.id}"
    assert_response :ok
    assert_equal 0, acc.balance
  end

  test "should return success response if account does exist and balance different from default zero" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    acc = Account.create(user: @user, balance: 10)
    get "/accounts/#{acc.id}"
    assert_response :ok
    assert_equal 10, acc.balance
    # assert new account has been linked to current logged user
    assert_equal acc.user_id, @user.id
  end

  test "should create an account with balance different than zero using post" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    post "/accounts/", params: {balance: 10, user: @user}
    assert_response :ok
  end

  test "should not create an account with balance less than zero" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    post "/accounts/", params: {:balance => -10}
    assert_response :not_found
  end

  test "should not create an account with null balance" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user
    post "/accounts/", params: {:balance => :null}
    assert_response :not_found
  end
end
