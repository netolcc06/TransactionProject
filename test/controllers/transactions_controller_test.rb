require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "should create transaction with existing accounts" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc1 = Account.create!(:balance => 40, user: @user)
    acc2 = Account.create!(:balance => 30, user: @user)
    assert_equal acc1.user_id, @user.id
    assert_equal acc2.user_id, @user.id

    post "/transactions", params: {amount: 30, source_id: acc1.id, destiny_id: acc2.id}
    assert_response :success

    assert_equal 10, acc1.reload.balance
    assert_equal 60, acc2.reload.balance
  end

  test "should not create transaction due to non existing accounts" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc1 = Account.create!(:balance => 40, user: @user)
    acc2 = Account.create!(:balance => 30, user: @user)

    post "/transactions", params: {:amount => 30, :source_id => acc1.id, :destiny_id => -1}

    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Invalid destiny account", response_body["message"]

    assert_equal 40, acc1.balance
    assert_equal 30, acc2.balance
  end

  test "should not create transaction due to not enough balance at source account" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc1 = Account.create!(:balance => 40, user: @user)
    acc2 = Account.create!(:balance => 30, user: @user)

    post "/transactions", params: {:amount => 50, :source_id => acc1.id, :destiny_id => acc2.id}
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Not enough credit for such transaction", response_body["message"]
  end

  test "should not create transaction where source and destiny accounts are the same" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc = Account.create!(:balance => 40, user: @user)

    post "/transactions", params: {:amount => 50, :source_id => acc.id, :destiny_id => acc.id}
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "You cannot transfer money to the same origin account", response_body["message"]
  end

  test "should not create transaction due to negative amount" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc1 = Account.create!(:balance => 40, user: @user)
    acc2 = Account.create!(:balance => 30, user: @user)

    post "/transactions", params: {:amount => -50, :source_id => acc1.id, :destiny_id => acc2.id}

    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Invalid amount", response_body["message"]

    assert_equal 40, acc1.balance
    assert_equal 30, acc2.balance
  end

  test "should not create transaction due to nil amount" do
    @user = User.create!(email: "doesnotexist@test.com", password: "password")
    sign_in @user

    acc1 = Account.create!(:balance => 40, user: @user)
    acc2 = Account.create!(:balance => 30, user: @user)

    post "/transactions", params: {:amount => nil, :source_id => acc1.id, :destiny_id => acc2.id}
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Invalid amount", response_body["message"]

    assert_equal 40, acc1.balance
    assert_equal 30, acc2.balance
  end

  test "should not allow transfer money from a source account that does not belong to the authenticated user" do
    @user1 = User.create!(email: "doesnotexist1@test.com", password: "password")
    @user2 = User.create!(email: "doesnotexist2@test.com", password: "password")
    sign_in @user1

    acc1 = Account.create!(:balance => 40, user: @user2)
    acc2 = Account.create!(:balance => 30, user: @user1)

    post "/transactions", params: {:amount => 20, :source_id => acc1.id, :destiny_id => acc2.id}
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Account does not belong to the user", response_body["message"]

    assert_equal 40, acc1.balance
    assert_equal 30, acc2.balance
  end
end
