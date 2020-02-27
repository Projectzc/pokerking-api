class AddTransferToCashQueues < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queues, :transfer, :boolean, default: false, comment: '是否是transfer'
    add_column :cash_queues, :currency, :string, default: '', comment: '货币类型'
  end
end
