class AddConfirmedToCashQueueMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queue_members, :confirmed, :boolean, default: true, comment: '用于区分是来自于APP还是后端程序创建, 默认后端'
  end
end
