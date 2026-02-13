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
class Reader < ApplicationRecord
  has_many :borrowings
  has_many :books, through: :borrowings

  validates :library_card_number, presence: true, uniqueness: true, format: { with: /\A\d{6}\z/, message: "must be a six-digit number" }
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
