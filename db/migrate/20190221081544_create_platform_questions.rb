class CreatePlatformQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_questions do |t|
      t.text :description, comment: '图文内容'
      t.timestamps
    end
  end
end
