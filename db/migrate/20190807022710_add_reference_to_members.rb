class AddReferenceToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queue_members, :user_id, :string, default: '', comment: '如果该字段为空，说明用户是后端添加的，否则是扫码注册的'
    add_index :cash_queue_members, :nickname
  end
end
