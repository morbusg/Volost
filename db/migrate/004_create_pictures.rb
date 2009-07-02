class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer    :parent_id, :size, :width, :height, :db_file_id
      t.string     :comment, :content_type, :filename, :type, :thumbnail
      t.references :user, :message
    end
  end

  def self.down
    drop_table :pictures
  end
end
