class AddMainEventIdToInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :infos, :main_event_id, :bigint
    add_column :infos, :only_show_in_event, :boolean, default: false, comment: '只显示在赛事中'
  end
end
