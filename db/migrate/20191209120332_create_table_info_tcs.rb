class CreateTableInfoTcs < ActiveRecord::Migration[5.2]
  def change
    create_table :info_tcs do |t|
      t.string :title, comment: '新闻标题'
      t.string :image
      t.string :source, comment: '来源'
      t.text :description
      t.boolean :published, default: false
      t.bigint :main_event_id
      t.boolean :only_show_in_event, default: false, comment: '只显示在赛事中'
      t.boolean :hot, default: false, comment: '是否上热门'
      t.float :position, default: 0.0, comment: '排序字段'
      t.integer :favorites_count, default: 0
      t.string :location, default: '', comment: '赛事主办地点'
      t.timestamps
    end
  end
end

