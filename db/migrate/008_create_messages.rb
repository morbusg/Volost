class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references  :commune, :user, :topic, :receiver
      t.string      :title, :type, :author
      t.boolean     :sticky, :locked, :default => 0
      t.integer     :replies_count, :pictures_count, :choices_count, :default => 0
      t.integer     :latest_id
      t.text        :body, :body_html
      t.timestamps
    end
    add_index :messages, [:topic_id, :commune_id, :user_id, :type]
  end

  def self.down
    drop_table :messages
    remove_index :messages, [:topic_id, :commune_id, :user_id, :type]
  end
end
