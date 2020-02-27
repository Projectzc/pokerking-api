class CreateEventInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :event_infos do |t|
      t.references :main_event
      t.string :title, comment: '新闻标题'
      t.string :image
      t.text :description
      t.boolean :published, default: false
      t.timestamps
    end
  end
end
