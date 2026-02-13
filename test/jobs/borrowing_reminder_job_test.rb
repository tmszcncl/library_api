require "test_helper"

class BorrowingReminderJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  setup do
    @reader = readers(:one)
    @book = books(:one)
  end

  test "sends reminder 3 days before due date" do
    # borrowed_at = 27 days ago => due in 3 days
    borrowing = Borrowing.create!(reader: @reader, book: @book, borrowed_at: 27.days.ago)

    assert_emails 1 do
      BorrowingReminderJob.perform_now
    end

    borrowing.reload
    assert_not_nil borrowing.reminder_3_days_sent_at
    assert_nil borrowing.due_date_reminder_sent_at
  end

  test "sends reminder on due date" do
    # borrowed_at = 30 days ago => due today
    borrowing = Borrowing.create!(reader: @reader, book: @book, borrowed_at: 30.days.ago)

    assert_emails 1 do
      BorrowingReminderJob.perform_now
    end

    borrowing.reload
    assert_not_nil borrowing.due_date_reminder_sent_at
    # It might also send the 3-day reminder if the logic isn't careful,
    # but my logic checks: if 3_day_sent.nil? && Time.current >= (due - 3) && Time.current < due
    # If due today (Time.current >= due), the first condition (Time.current < due) fails.
    # So it should only send the due date reminder.
    assert_nil borrowing.reminder_3_days_sent_at
  end

  test "does not send duplicate reminders" do
    borrowing = Borrowing.create!(
      reader: @reader,
      book: @book,
      borrowed_at: 27.days.ago,
      reminder_3_days_sent_at: 1.hour.ago
    )

    assert_no_emails do
      BorrowingReminderJob.perform_now
    end
  end

  test "does not send reminder for returned books" do
    borrowing = Borrowing.create!(
      reader: @reader,
      book: @book,
      borrowed_at: 27.days.ago,
      returned_at: 1.day.ago
    )

    assert_no_emails do
      BorrowingReminderJob.perform_now
    end
  end

  test "does not send reminder if not yet time" do
    # borrowed_at = 10 days ago => due in 20 days
    borrowing = Borrowing.create!(reader: @reader, book: @book, borrowed_at: 10.days.ago)

    assert_no_emails do
      BorrowingReminderJob.perform_now
    end
  end
end
