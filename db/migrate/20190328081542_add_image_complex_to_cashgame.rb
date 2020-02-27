class AddImageComplexToCashgame < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :image_complex, :string, default: '', comment: '繁体图片'
  end
end
