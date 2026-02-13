class BorrowingMailer < ApplicationMailer
  def reminder_3_days(borrowing)
    @borrowing = borrowing
    @reader = borrowing.reader
    @book = borrowing.book
    @due_date = borrowing.created_at + 30.days

    mail(to: @reader.email, subject: "Reminder: Book due in 3 days")
  end

  def due_date_reminder(borrowing)
    @borrowing = borrowing
    @reader = borrowing.reader
    @book = borrowing.book
    @due_date = borrowing.created_at + 30.days

    mail(to: @reader.email, subject: "Reminder: Book due today")
  end
end
