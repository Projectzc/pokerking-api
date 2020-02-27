class AddBlindNavigationToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :blind_navigation, :string, default: '', comment: '图片导航'
  end
end
