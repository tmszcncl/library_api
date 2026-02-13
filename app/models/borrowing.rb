# == Schema Information
#
# Table name: borrowings
#
#  id                        :bigint           not null, primary key
#  borrowed_at               :datetime
#  due_date_reminder_sent_at :datetime
#  reminder_3_days_sent_at   :datetime
#  returned_at               :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  book_id                   :bigint           not null
#  reader_id                 :bigint           not null
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
class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :reader

  validates :borrowed_at, presence: true
end
