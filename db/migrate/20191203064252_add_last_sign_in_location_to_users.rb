class AddLastSignInLocationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_sign_in_locations, :string, default: '', comment: '上次登录位置'
  end
end
