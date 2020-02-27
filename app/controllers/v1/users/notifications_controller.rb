module V1
  module Users
    class NotificationsController < ApplicationController
      include UserAuthorize
      before_action :user_self_required

      def index
        @apply_notifications = @current_user.notifies('apply').limit(30)
        @apply_notification_unread = @current_user.notify_apply_unread_new
        @event_notifications = @current_user.notifies('event').limit(30) # event notifications是所有人共有
        @event_notification_unread = @current_user.notify_event_unread_new
      end

      def unread_remind
        @unread_count = @current_user.notify_apply_unread_new + @current_user.notify_event_unread_new
        @recent_notification = @current_user.notifications.order(id: :desc).first
      end

      def read
        @current_user.notifications.find(params[:id]).update(read: true)
        render_api_success
      end

      def destroy
        @current_user.notifications.find(params[:id]).destroy
        render_api_success
      end

      def read_all
        if params[:type].eql? 'apply'
          @current_user.update(notify_apply_unread: 0)
        elsif params[:type].eql? 'event'
          @current_user.update(notify_event_unread: 0)
        elsif params[:type].eql? 'all'
          @current_user.update(notify_apply_unread: 0)
          @current_user.update(notify_event_unread: 0)
        else
          raise_error 'params_missing'
        end
        render_api_success
      end
    end
  end
end
