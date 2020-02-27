class AddLocationToMainEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :main_events, :location, :string, default: '', comment: '赛事主办地点'
  end
end
