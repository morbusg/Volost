class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string      :title
      t.boolean     :public
      t.integer     :position
    end
  end

  def self.down
    drop_table :categories
  end
end
