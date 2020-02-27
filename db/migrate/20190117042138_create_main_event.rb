class CreateMainEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :main_events do |t|
      t.string   'name', comment: '赛事的名称'
      t.string   'logo', comment: '赛事的logo'
      t.datetime 'begin_time',  comment: '赛事开始时间'
      t.datetime 'end_time',    comment: '赛事结束的时间'
      t.string   'event_state', default: 'unbegin', comment: '赛事的状态 unbegin 未开始'
      t.boolean  'published',   default: false,  comment: '该赛事是否已发布'
      t.text     'description', comment: '详情描述'
      t.timestamps
    end
  end
end
