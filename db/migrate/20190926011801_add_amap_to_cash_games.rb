class AddAmapToCashGames < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :amap_poiid, :string, limit: 30, comment: '高德地图的 POI地点的ID'
    add_column :cash_games, :amap_location, :string, limit: 32, comment: '高德的经纬度'
  end
end
