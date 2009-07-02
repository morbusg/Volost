class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.boolean :active, :admin, :bot, :moderator, :default => false
      t.date    :birthday
      t.datetime :last_request_at, :last_login_at, :current_login_at
      t.integer :login_count, :failed_login_count, :default => 0#, :null => false
      t.integer :messages_count, :pictures_count, :received_private_messages_count, :default => 0
      t.string  :login, :crypted_password, :password_salt#, :null => false
      t.string  :current_login_ip, :last_login_ip
      t.string  :designation, :default => I18n.t(:member)
      t.string  :location
      t.string  :persistence_token, :single_access_token#, :null => false
      t.string  :time_zone
      t.text    :signature, :signature_html, :ips
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
