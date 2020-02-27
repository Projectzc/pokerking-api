class AddStraddleToCashQueues < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queues, :straddle, :string, default: '0', comment: '大盲前注'
    add_column :cash_queues, :position, :float, default: 0.0, comment: '用于拖拽排序'
    add_column :cash_queues, :queue_type, :string, default: 'basic', comment: '盲注类型：basic|high limit|transfer request'
  end
end
