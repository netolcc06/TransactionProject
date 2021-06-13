require "test_helper"

class TransactionTest < ActiveSupport::TestCase

  test "transaction should not be created without a source account" do
    user = User.create!(email: "test@test.com", password: "123456")
    destiny = Account.create!(balance: 30, user: user)
    assert_raise (ActiveRecord::RecordInvalid) do
      Transaction.create!(destiny: destiny, amount: 10)
    end
  end

  test "transaction should not be created without a destiny account" do
    user = User.create!(email: "test@test.com", password: "123456")
    source = Account.create!(balance: 30, user: user)
    assert_raise (ActiveRecord::RecordInvalid) do
      Transaction.create!(source: source, amount: 10)
    end
  end

  test "transaction should be created" do
    user = User.create!(email: "test@test.com", password: "123456")
    source = Account.create!(balance: 30, user: user)
    destiny = Account.create!(balance: 90, user: user)
    tr = Transaction.create!(source: source, destiny: destiny, amount: 10)
    assert_not_nil tr.id
  end

  test "transaction should not be created because amount to be transferred is negative" do
    user = User.create!(email: "test@test.com", password: "123456")
    source = Account.create!(balance: 30, user: user)
    destiny = Account.create!(balance: 90, user: user)
    assert_raise (ActiveRecord::RecordInvalid) do
      Transaction.create!(source: source, destiny: destiny, amount: -10)
    end
  end

  test "transaction should not be created without specified amount" do
    user = User.create!(email: "test@test.com", password: "123456")
    source = Account.create!(balance: 30, user: user)
    destiny = Account.create!(balance: 90, user: user)
    assert_raise (ActiveRecord::RecordInvalid) do
      Transaction.create!(source: source, destiny: destiny)
    end
  end

  test "transaction should not be created with amount equals to zero" do
    user = User.create!(email: "test@test.com", password: "123456")
    source = Account.create!(balance: 30, user: user)
    destiny = Account.create!(balance: 90, user: user)
    assert_raise (ActiveRecord::RecordInvalid) do
      Transaction.create!(source: source, destiny: destiny, amount: 0)
    end
  end
end
