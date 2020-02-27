class AddAccountIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_id, :string, default: 'no_set', comment: '账户id'
  end
end
