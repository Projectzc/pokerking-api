class AddBirthdayToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birthday, :date, default: '', comment: '出生日期'
  end
end
