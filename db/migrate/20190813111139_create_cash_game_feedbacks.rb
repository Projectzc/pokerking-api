class CreateCashGameFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_game_feedbacks do |t|
      t.references :user
      t.references :cash_game
      t.string  :email, comment: '用户的邮箱'
      t.integer :sense, default: 2, comment: '使用感满意度'
      t.string  :content, comment: '反馈内容'
      t.string  :image, comment: '反馈用户上传的图片'
      t.boolean :dealt, comment: '是否已处理'
      t.timestamps
    end
  end
end
