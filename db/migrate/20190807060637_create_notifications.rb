class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :notify_type, default: '', comment: '消息类型'
      t.string :title, default: '', comment: '消息的标题'
      t.text :content, limit: 65535, comment: '内容'
      t.string :source_type, comment: '产生消息的出处'
      t.integer :source_id, comment: '产生消息的出处'
      t.text :extra_data, limit: 65535, comment: '使用json存额外信息'
      t.string :color_type, comment: '颜色类型: success 成功，failure 失败'
      t.boolean :read, default: false, comment: '是否已读'
      t.timestamps
    end
    add_index :notifications, [:source_type, :source_id]
  end
end
