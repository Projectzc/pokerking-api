class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string   :user_uuid, limit: 32, null: false, comment: '用户的uuid'
      t.string   :nickname, limit: 32, comment: '用户的昵称，唯一'
      t.string   :password, limit: 32, comment: '用户的密码'
      t.string   :password_salt, default: '', comment: '密码盐值'
      t.string   :gender, default: '', comment: '用户性别'
      t.string   :email, default: '', comment: '用户邮箱'
      t.string   :country_code, default: '86', comment: '国家区号'
      t.string   :mobile, default: '', commnet: '用户手机号'
      t.string   :avatar, default: '', comment: '用户头像'
      t.datetime :reg_date, default: '', comment: '注册日期'
      t.datetime :last_visit, default: '', comment: '上次访问时间'
      t.string   :last_sign_in_ip, default: '', comment: '上次登录ip'
      t.integer  :login_count, default: 0, comment: '登录次数'
      t.integer  :login_days, default: 0, comment: '登录天数'
      t.integer  :continuous_login_days, default: 0, comment: '连续登录天数'
      t.float    :lat, limit: 24
      t.float    :lng, limit: 24
      t.string   :mark, default: '', comment: '后台备注'
      t.timestamps
    end
  end
end
