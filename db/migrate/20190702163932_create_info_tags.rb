class CreateInfoTags < ActiveRecord::Migration[5.2]
  def change
    create_table :info_tags do |t|
      t.string :name, default: '', comment: '资讯标签'
      t.string :name_en, default: '', comment: '资讯英文标签'
      t.timestamps
    end
  end
end
