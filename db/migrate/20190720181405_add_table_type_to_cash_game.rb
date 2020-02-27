class AddTableTypeToCashGame < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_games, :table_type, :string, default: 'Macao', comment: '盲注类型'
  end
end
