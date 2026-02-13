require "test_helper"

class ReadersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get readers_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)

    assert_instance_of Array, json_response
    assert_equal Reader.count, json_response.size

    # Verify some data from fixtures
    reader = json_response.first
    assert_not_nil reader["full_name"]
    assert_not_nil reader["email"]
    assert_not_nil reader["library_card_number"]
  end
end
