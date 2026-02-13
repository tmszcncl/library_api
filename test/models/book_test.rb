# == Schema Information
#
# Table name: books
#
#  id            :bigint           not null, primary key
#  author        :string
#  serial_number :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_books_on_serial_number  (serial_number) UNIQUE
#
require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "should be valid with all attributes" do
    book = Book.new(serial_number: "999999", title: "Test Book", author: "Test Author")
    assert book.valid?
  end

  test "should be invalid without serial_number" do
    book = Book.new(title: "Test Book", author: "Test Author")
    assert_not book.valid?
  end

  test "should be invalid with non-6-digit serial_number" do
    book = Book.new(serial_number: "12345", title: "Test Book", author: "Test Author")
    assert_not book.valid?
    book.serial_number = "1234567"
    assert_not book.valid?
    book.serial_number = "123a56"
    assert_not book.valid?
  end

  test "should be invalid with duplicate serial_number" do
    duplicate_book = Book.new(serial_number: books(:one).serial_number, title: "Test Book", author: "Test Author")
    assert_not duplicate_book.valid?
  end

  test "should be invalid without title" do
    book = Book.new(serial_number: "123456", author: "Test Author")
    assert_not book.valid?
  end

  test "should be invalid without author" do
    book = Book.new(serial_number: "123456", title: "Test Book")
    assert_not book.valid?
  end
end
