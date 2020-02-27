class AddLiveUrlToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :main_events, :live_url, :string, default: '', comment: '赛事直播地址'
  end
end
