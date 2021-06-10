require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should return error response if account does not exist" do
    get "/accounts/1"
    assert_response :not_found
  end

  test "should return success response if account does exist and balance initialized to default zero" do
    acc = Account.create
    get "/accounts/#{acc.id}"
    assert_response :ok
    assert_equal 0, acc.balance
  end

  test "should return success response if account does exist and balance different from default zero" do
    acc = Account.create(:balance => 10)
    get "/accounts/#{acc.id}"
    assert_response :ok
    assert_equal 10, acc.balance
  end

  test "should create an account with balance different than zero" do
    post "/accounts/", params: {:balance => 10}
    assert_response :ok
  end

  test "should not create an account with balance less than zero" do
    post "/accounts/", params: {:balance => -10}
    assert_response :not_found
  end

  test "should not create an account with null balance" do
    post "/accounts/", params: {:balance => :null}
    assert_response :not_found
  end
end
