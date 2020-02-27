class CreateCashGames < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_games do |t|
      t.string :name, default: '', comment: '现金桌名字'
      t.string :image, default: '', comment: '现金桌列表显示图片'
      t.timestamps
    end

    create_table :cash_queues do |t|
      t.references :cash_game
      t.string  :small_blind, default: '0', comment: '最小盲注'
      t.string  :big_blind, default: '0', comment: '最大盲注'
      t.integer :table_numbers, default: 0, comment: '开办桌子的数量'
      t.integer :cash_queue_members_count, default: 0, comment: '排队人数'
      t.timestamps
    end

    create_table :cash_queue_members do |t|
      t.references :cash_queue
      t.string :nickname, default: '', comment: '现金桌排队人的昵称'
      t.timestamps
    end
  end
end
