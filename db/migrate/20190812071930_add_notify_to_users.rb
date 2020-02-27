class AddNotifyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apply_notify, :boolean, default: true
    add_column :users, :event_notify, :boolean, default: true
  end
end
