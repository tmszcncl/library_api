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

  test "should get index" do
    get books_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)

    assert_instance_of Array, json_response
    assert_equal Book.count, json_response.size

    # book(:one) is borrowed in borrowings.yml
    book_one = json_response.find { |b| b["serial_number"] == books(:one).serial_number }
    assert_equal "borrowed", book_one["status"]

    # book(:two) has a returned borrowing in borrowings.yml
    book_two = json_response.find { |b| b["serial_number"] == books(:two).serial_number }
    assert_equal "available", book_two["status"]
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

  test "should destroy book" do
    book = books(:one)
    assert_difference("Book.count", -1) do
      delete book_url(serial_number: book.serial_number), as: :json
    end

    assert_response :no_content
  end

  test "should return not found for non-existent book" do
    delete book_url(serial_number: "000000"), as: :json
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "Book not found", json_response["error"]
  end
end
