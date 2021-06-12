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

    assert_equal 10, acc1.balance
    assert_equal 60, acc2.balance
  end

  # test "should not create transaction due to non existing accounts" do
  #   acc1 = Account.create(:balance => 40)
  #   acc2 = Account.create(:balance => 30)
  #
  #   post "/transactions", params: {:amount => 30, :source_id => acc1.id, :destiny_id => -1}
  #
  #   assert_response :not_found
  #   assert_equal 40, acc1.balance
  #   assert_equal 30, acc2.balance
  # end
  #
  # test "should not create transaction due to not enough balance at source account" do
  #   acc1 = Account.create(:balance => 40)
  #   acc2 = Account.create(:balance => 30)
  #
  #   assert_raise(Exception){
  #     post "/transactions", params: {:amount => 50, :source_id => acc1.id, :destiny_id => acc2.id}
  #   }
  # end
  #
  # test "should not create transaction due to negative amount" do
  #   acc1 = Account.create(:balance => 40)
  #   acc2 = Account.create(:balance => 30)
  #
  #   post "/transactions", params: {:amount => -50, :source_id => acc1.id, :destiny_id => acc2.id}
  #
  #   assert_equal 40, acc1.balance
  #   assert_equal 30, acc2.balance
  # end
  #
  # test "should not create transaction due to null amount" do
  #   acc1 = Account.create(:balance => 40)
  #   acc2 = Account.create(:balance => 30)
  #
  #   post "/transactions", params: {:amount => :null, :source_id => acc1.id, :destiny_id => acc2.id}
  #
  #   assert_equal 40, acc1.balance
  #   assert_equal 30, acc2.balance
  # end
end
