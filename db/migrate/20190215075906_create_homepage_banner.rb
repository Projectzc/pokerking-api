class CreateHomepageBanner < ActiveRecord::Migration[5.2]
  def change
    create_table :homepage_banners do |t|
      t.references :source, polymorphic: true
      t.string  :image
      t.bigint  :position, default: 0, comment: '用于排序'
    end
  end
end
