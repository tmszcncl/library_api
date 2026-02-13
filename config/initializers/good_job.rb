Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.cron = {
    borrowing_reminders: {
      cron: "0 8 * * *", # Every day at 8 AM
      class: "BorrowingReminderJob"
    }
  }
end
