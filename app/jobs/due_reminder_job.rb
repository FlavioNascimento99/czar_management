class DueReminderJob < ApplicationJob
  queue_as :default

  def perform
    Task.includes(:assigned_to, :project)
        .where.not(status: Task.statuses[:concluida])
        .where.not(due_date: nil)
        .find_each do |task|
      action =
        if task.due_date == Date.tomorrow
          "due_soon"
        elsif task.due_date < Date.current
          "overdue"
        end
      next if action.nil?
      Notification.notify!(user: task.assigned_to, action: action, notifiable: task)
      TaskMailer.due_reminder(task.id, action).deliver_later
    end
  end
end
