require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should create transaction with existing accounts" do
    acc1 = Account.create(:balance => 40)
    acc2 = Account.create(:balance => 30)

    assert_equal 1, acc1.id
    assert_equal 2, acc2.id

    post "/transactions", params: {:amount => 30, :source_id => acc1.id, :destiny_id => acc2.id}

    assert_response :success
    assert_equal 10, acc1.reload.balance
    assert_equal 60, acc2.reload.balance
  end

  test "should not create transaction due to non existing accounts" do
    acc1 = Account.create(:balance => 40)
    acc2 = Account.create(:balance => 30)

    assert_equal 1, acc1.id
    assert_equal 2, acc2.id

    post "/transactions", params: {:amount => 30, :source_id => acc1.id, :destiny_id => 3}

    assert_response :not_found
    assert_equal 40, acc1.balance
    assert_equal 30, acc2.balance
  end

  test "should not create transaction due to not enough balance at source account" do
    acc1 = Account.create(:balance => 40)
    acc2 = Account.create(:balance => 30)

    assert_raise(Exception){
      post "/transactions", params: {:amount => 50, :source_id => acc1.id, :destiny_id => acc2.id}
    }
  end
end
