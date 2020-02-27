class AddPositionToCashGames < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :position, :float, default: 0.0, comment: '用于拖拽排序'
    add_column :cash_queue_members, :position, :float, default: 0.0, comment: '用于拖拽排序'
  end
end
