# == Schema Information
#
# Table name: borrowings
#
#  id          :bigint           not null, primary key
#  borrowed_at :datetime
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :bigint           not null
#  reader_id   :bigint           not null
#
# Indexes
#
#  index_borrowings_on_book_id    (book_id)
#  index_borrowings_on_reader_id  (reader_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (reader_id => readers.id)
#
require "test_helper"

class BorrowingTest < ActiveSupport::TestCase
  test "should be valid with all attributes" do
    borrowing = Borrowing.new(book: books(:one), reader: readers(:one), borrowed_at: Time.current)
    assert borrowing.valid?
  end

  test "should be invalid without book" do
    borrowing = Borrowing.new(reader: readers(:one), borrowed_at: Time.current)
    assert_not borrowing.valid?
  end

  test "should be invalid without reader" do
    borrowing = Borrowing.new(book: books(:one), borrowed_at: Time.current)
    assert_not borrowing.valid?
  end

  test "should be invalid without borrowed_at" do
    borrowing = Borrowing.new(book: books(:one), reader: readers(:one))
    assert_not borrowing.valid?
  end
end
