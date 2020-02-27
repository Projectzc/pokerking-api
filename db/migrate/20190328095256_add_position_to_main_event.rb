class AddPositionToMainEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :main_events, :position, :float, default: 0.0, comment: '用于拖拽排序'
  end
end
