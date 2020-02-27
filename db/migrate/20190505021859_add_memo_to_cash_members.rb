class AddMemoToCashMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queue_members, :memo, :string, default: '', comment: '备注'
  end
end
