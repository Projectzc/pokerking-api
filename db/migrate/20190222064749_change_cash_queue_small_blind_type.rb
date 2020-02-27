class ChangeCashQueueSmallBlindType < ActiveRecord::Migration[5.2]
  def change
    remove_column :cash_queues, :small_blind
    remove_column :cash_queues, :big_blind

    add_column :cash_queues, :small_blind, :integer, default: 0, comment: '小盲注'
    add_column :cash_queues, :big_blind, :integer, default: 0, comment: '大盲注'

    drop_table :platform_questions
  end
end
