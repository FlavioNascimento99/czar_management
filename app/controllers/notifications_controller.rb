class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications.includes(:actor).recent.page(params[:page]).per(20)
  end

  def mark_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_read!
    redirect_to notifications_path
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "Todas marcadas como lidas!"
  end
end
