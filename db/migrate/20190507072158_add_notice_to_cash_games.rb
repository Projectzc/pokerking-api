class AddNoticeToCashGames < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :notice, :string, default: '', comment: '扑克房消息'
    add_column :cash_queues, :notice, :string, default: '', comment: '盲注结构消息'
  end
end
