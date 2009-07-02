class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.integer     :parent_id, :size, :width, :height, :db_file_id
      t.string      :comment, :content_type, :filename, :type, :thumbnail
      t.references  :user
    end
    add_index :avatars, :user_id
  end

  def self.down
    drop_table :avatars
  end
end
