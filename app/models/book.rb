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
class Book < ApplicationRecord
  has_many :borrowings
  has_many :readers, through: :borrowings

  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/, message: "must be a six-digit number" }
  validates :title, presence: true
  validates :author, presence: true
end
