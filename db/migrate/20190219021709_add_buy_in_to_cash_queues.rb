class AddBuyInToCashQueues < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queues, :buy_in, :string, default: '', comment: '买入'
    add_column :cash_queues, :table_no, :string, default: '', comment: '桌子编号'
    add_column :cash_queue_members, :canceled, :boolean, default: false, comment: '排队是否取消'
  end
end
