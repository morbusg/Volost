class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.references  :user, :category, :commune
      t.string      :title
    end
    add_index :groups, [:user_id, :category_id, :commune_id]
  end

  def self.down
    drop_table :groups
  end
end
