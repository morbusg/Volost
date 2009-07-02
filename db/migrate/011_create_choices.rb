class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.references :topic
      t.string :description
      t.integer :votes_count, :default => 0
    end
  end

  def self.down
    drop_table :choices
  end
end
