require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should return error response if account does not exist" do
    get "/accounts/1"
    assert_response :not_found
  end

  test "should return success response if account does exist and balance initialized to default zero" do
    acc = Account.create
    get "/accounts/1"
    assert_response :ok
    assert_equal 0, acc.balance
  end

  test "should return success response if account does exist and balance different from default zero" do
    acc = Account.create(:balance => 10)
    get "/accounts/1"
    assert_response :ok
    assert_equal 10, acc.balance
  end
end
