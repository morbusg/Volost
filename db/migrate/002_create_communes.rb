class CreateCommunes < ActiveRecord::Migration
  def self.up
    create_table :communes do |t|
      t.references  :category
      t.integer     :position
      t.integer     :topics_count, :default => 0
      t.string      :title, :description
      t.integer     :latest_id
      t.timestamps
    end
  end

  def self.down
    drop_table :communes
  end
end
