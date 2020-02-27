class CreateEventSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :event_schedules do |t|
      t.references :main_event
      t.string :name, comment: '名称'
      t.string :event_type
      t.string :event_num, comment: '编码'
      t.string :buy_in
      t.string :starting_stack
      t.integer :entries
      t.string :schedule_pdf
      t.datetime :begin_time, comment: '开始时间'
      t.datetime :reg_open, comment: '开始登记'
      t.datetime :reg_close, comment: '结束登记'
      t.timestamps
    end
  end
end
