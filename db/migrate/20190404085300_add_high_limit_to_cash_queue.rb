class AddHighLimitToCashQueue < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_queues, :high_limit, :boolean, default: false, comment: '是否是高额桌'
    add_column :cash_queues, :table_people, :string, default: '', comment: '桌子对应的人数'
  end
end
