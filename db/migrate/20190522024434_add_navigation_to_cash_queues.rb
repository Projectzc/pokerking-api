class AddNavigationToCashQueues < ActiveRecord::Migration[5.2]
  def change
    remove_column :cash_games, :blind_navigation
    add_column :cash_queues, :navigation, :string, default: '', comment: '盲注图片'
  end
end
