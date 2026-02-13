# == Schema Information
#
# Table name: readers
#
#  id                  :bigint           not null, primary key
#  email               :string
#  full_name           :string
#  library_card_number :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_readers_on_email                (email) UNIQUE
#  index_readers_on_library_card_number  (library_card_number) UNIQUE
#
require "test_helper"

class ReaderTest < ActiveSupport::TestCase
  test "should be valid with all attributes" do
    reader = Reader.new(library_card_number: "999999", full_name: "Test Reader", email: "unique@example.com")
    assert reader.valid?
  end

  test "should be invalid without library_card_number" do
    reader = Reader.new(full_name: "Test Reader", email: "test@example.com")
    assert_not reader.valid?
  end

  test "should be invalid with non-6-digit library_card_number" do
    reader = Reader.new(library_card_number: "12345", full_name: "Test Reader", email: "test@example.com")
    assert_not reader.valid?
    reader.library_card_number = "1234567"
    assert_not reader.valid?
  end

  test "should be invalid with duplicate library_card_number" do
    duplicate_reader = Reader.new(library_card_number: readers(:one).library_card_number, full_name: "Test Reader", email: "different@example.com")
    assert_not duplicate_reader.valid?
  end

  test "should be invalid with duplicate email" do
    duplicate_reader = Reader.new(library_card_number: "654321", full_name: "Test Reader", email: readers(:one).email)
    assert_not duplicate_reader.valid?
  end

  test "should be invalid with incorrect email format" do
    reader = Reader.new(library_card_number: "123456", full_name: "Test Reader", email: "invalid-email")
    assert_not reader.valid?
  end
end
