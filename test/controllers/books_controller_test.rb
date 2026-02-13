require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_params = {
      book: {
        title: "The Hobbit",
        author: "J.R.R. Tolkien",
        serial_number: "111222"
      }
    }
  end

  test "should create book" do
    assert_difference("Book.count") do
      post books_url, params: @book_params, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal @book_params[:book][:title], json_response["title"]
    assert_equal @book_params[:book][:serial_number], json_response["serial_number"]
  end

  test "should not create book with invalid serial number" do
    @book_params[:book][:serial_number] = "123"
    assert_no_difference("Book.count") do
      post books_url, params: @book_params, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Serial number must be a six-digit number"
  end

  test "should not create book with missing title" do
    @book_params[:book].delete(:title)
    assert_no_difference("Book.count") do
      post books_url, params: @book_params, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Title can't be blank"
  end

  test "should not create book with duplicate serial number" do
    Book.create!(@book_params[:book])
    
    assert_no_difference("Book.count") do
      post books_url, params: @book_params, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Serial number has already been taken"
  end
end
