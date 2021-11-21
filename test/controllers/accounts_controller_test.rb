require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    sign_in users(:one)
    post user_session_url
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url, params: { account: { amount: @account.amount, currency_id: @account.currency_id, user_id: @account.user_id } }
    end

    assert_redirected_to account_url(Account.last)
  end
  
end
