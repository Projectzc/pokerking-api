class AddHotToInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :infos, :hot, :boolean, default: false, comment: '是否上热门'
    add_column :infos, :position, :float, default: 0.0, comment: '排序字段'
  end
end
