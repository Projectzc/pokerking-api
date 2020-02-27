class AddPreviewToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :preview, :boolean, default: false, comment: '是否有预览权限'
  end
end
