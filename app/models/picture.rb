class Picture < ActiveRecord::Base
  belongs_to :message, :counter_cache => true
  belongs_to :user, :counter_cache => true

  has_attachment :content_type => :image,
    :storage => :file_system,
    :path_prefix => 'public/images/pictures',
    :resize_to => '600>',
    :thumbnails => { :thumb => 'x100>' }

  validates_as_attachment
end
