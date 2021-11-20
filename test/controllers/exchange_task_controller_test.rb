require "test_helper"

class ExchangeTaskControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exchange_task_index_url
    assert_response :success
  end
end
