class CreateUserExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :user_extras do |t|
      t.references :user
      t.string :real_name, limit: 50, comment: '真实姓名'
      t.string :cert_type, limit: 50, default: '', comment: '证件类型'
      t.string :cert_no, comment: '证件号码'
      t.string :memo, comment: '备忘'
      t.string :img_front, comment: '证件正面'
      t.string :img_back, comment: '证件反面'
      t.string :status, default: 'init', comment: '证件审核状态'
      t.boolean :default, default: false, comment: '是否默认'
      t.timestamps
    end

    add_column :users, :country, :string, default: ''
  end
end
