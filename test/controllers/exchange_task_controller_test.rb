require "test_helper"

class ExchangeTaskControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    sign_in users(:one)
    post user_session_url
  end

  test "should get index" do
    get exchange_tasks_url
    assert_response :success
  end
end
