class BorrowingReminderJob < ApplicationJob
  queue_as :default

  def perform
    Borrowing.where(returned_at: nil).find_each do |borrowing|
      due_date = borrowing.borrowed_at + 30.days

      # 3 days before due date
      if borrowing.reminder_3_days_sent_at.nil? && Time.current >= (due_date - 3.days) && Time.current < due_date
        BorrowingMailer.reminder_3_days(borrowing).deliver_later
        borrowing.update!(reminder_3_days_sent_at: Time.current)
      end

      # On due date
      if borrowing.due_date_reminder_sent_at.nil? && Time.current >= due_date
        BorrowingMailer.due_date_reminder(borrowing).deliver_later
        borrowing.update!(due_date_reminder_sent_at: Time.current)
      end
    end
  end
end
