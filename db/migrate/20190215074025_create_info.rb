class CreateInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :infos do |t|
      t.string :title, comment: '新闻标题'
      t.string :image
      t.string :source, comment: '来源'
      t.text :description
      t.boolean :published, default: false
      t.timestamps
    end
  end
end
