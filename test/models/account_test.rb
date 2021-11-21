require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "Normal params" do
    user = users(:one)
    currency = currencies(:one)
    account = Account.new(user_id: user.id, currency_id: currency.id, amount: BigDecimal(100))
    assert account.valid?
  end

  test "not less than zero" do
    user = users(:one)
    currency = currencies(:one)
    account = Account.new(user_id: user.id, currency_id: currency.id, amount: BigDecimal(-100))
    assert !account.valid?
  end

end
