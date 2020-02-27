class AddEventUnreadCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notify_event_unread, :integer, default: 0, commnet: '即时新闻未读数'
    add_column :users, :notify_apply_unread, :integer, default: 0, comment: '报名消息未读数'
  end
end
