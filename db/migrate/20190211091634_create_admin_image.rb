class CreateAdminImage < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_images do |t|
      t.references :imageable, polymorphic: true, index: true
      t.string :image
      t.timestamps
    end
  end
end
