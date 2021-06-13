require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should not create account because there is no user associated" do
    assert_raise (ActiveRecord::RecordInvalid) do
      acc = Account.create!(balance: 30)
    end
  end

  test "should create account because there is an user associated to it" do
    user = User.create!(email: "test@test.com", password: "123456")
    acc = Account.create!(balance: 30, user: user)
    assert_equal user.id, acc.user_id
  end

  test "should not create account with negative balance value" do
    assert_raise (ActiveRecord::RecordInvalid) do
      user = User.create!(email: "test@test.com", password: "123456")
      acc = Account.create!(balance: -100, user: user)
    end
  end

  test "should not create account without balance equals to nil" do
    assert_raise (ActiveRecord::RecordInvalid) do
      user = User.create!(email: "test@test.com", password: "123456")
      acc = Account.create!(balance: nil, user: user)
    end
  end
end
