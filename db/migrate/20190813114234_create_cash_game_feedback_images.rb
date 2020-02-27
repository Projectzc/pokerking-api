class CreateCashGameFeedbackImages < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_game_feedback_images do |t|
      t.references :cash_game_feedback
      t.string :image, default: '', comment: '反馈图片'
      t.timestamps
    end
  end
end
