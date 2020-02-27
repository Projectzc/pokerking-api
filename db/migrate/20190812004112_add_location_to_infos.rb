class AddLocationToInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :infos, :location, :string, default: '', comment: '赛事主办地点'
  end
end
