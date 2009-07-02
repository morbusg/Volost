class Avatar < ActiveRecord::Base
  belongs_to :user
  belongs_to :message, :counter_cache => true

  has_attachment :content_type => :image,
    :storage => :file_system,
    :path_prefix => 'public/images/avatars',
    :partition => false,
    :resize_to => '80x80>'

  validates_as_attachment
end
