class CreateInfoTagRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :info_tag_relations do |t|
      t.belongs_to :info, index: true
      t.belongs_to :info_tag, index: true
      t.timestamps
    end
  end
end
