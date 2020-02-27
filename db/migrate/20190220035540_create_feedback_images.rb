class CreateFeedbackImages < ActiveRecord::Migration[5.2]
  def change
    create_table :feedback_images do |t|
      t.references :feedback
      t.string :image, default: '', comment: '反馈图片'
      t.timestamps
    end
  end
end
