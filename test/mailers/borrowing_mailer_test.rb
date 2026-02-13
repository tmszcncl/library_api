require "test_helper"

class BorrowingMailerTest < ActionMailer::TestCase
  setup do
    @reader = readers(:one)
    @book = books(:one)
    @borrowing = Borrowing.create!(reader: @reader, book: @book, borrowed_at: 10.days.ago)
  end

  test "reminder_3_days" do
    email = BorrowingMailer.reminder_3_days(@borrowing)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @reader.email ], email.to
    assert_equal "Reminder: Book due in 3 days", email.subject
    assert_match "due in 3 days", email.body.encoded
    assert_match @book.title, email.body.encoded
  end

  test "due_date_reminder" do
    email = BorrowingMailer.due_date_reminder(@borrowing)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @reader.email ], email.to
    assert_equal "Reminder: Book due today", email.subject
    assert_match "due TODAY", email.body.encoded
    assert_match @book.title, email.body.encoded
  end
end
