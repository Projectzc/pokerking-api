class AddImageEnToCashgame < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :image_en, :string, default: '', comment: '英文图片'
  end
end
