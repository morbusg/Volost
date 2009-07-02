class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user, :choice
    end
  end

  def self.down
    drop_table :votes
  end
end
