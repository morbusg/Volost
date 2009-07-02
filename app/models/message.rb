class Message < ActiveRecord::Base
  # TODO: non-xhr preview
  require 'text_mangler'
  include TextMangler

  attr_accessible :body, :pictures_attributes

  belongs_to  :user, :counter_cache => true
  belongs_to  :commune
  has_many    :pictures, :dependent => :destroy
  accepts_nested_attributes_for :pictures,
    :reject_if => proc {|attr| attr.all? {|k,v| v.blank?}} 

  markdown :body

  validates_presence_of :user
  validates_associated  :pictures
  validates_presence_of :body
  validates_length_of   :body, :minimum => 3

end

class Topic < Message
  attr_accessible :title, :choices_attributes
  default_scope :order => 'sticky, updated_at'

  belongs_to  :commune, :counter_cache => true
  belongs_to  :latest, :class_name => 'Message'
  has_many    :choices
  has_many    :votes, :through => :choices
  has_many    :replies, :dependent => :destroy, :order => 'created_at ASC'
  accepts_nested_attributes_for :choices,
    :reject_if => proc {|attr| attr.all? {|k,v| v.blank?}} 

  validates_presence_of   :commune, :title
  validates_length_of     :title, :in => 3..60
  validates_uniqueness_of :title
  validates_associated    :pictures

  # Access control {{{
  def creatable_by?(user)
    return false if user.respond_to?(:sup?)
    return false if !user.active?
    return true if commune.category.public?
    commune.category.users.include?(user)
  end

  def viewable_by?(user)
    return true if commune.category.public?
    return false if user.is_a?(AnonymousUser)
    return false unless user.active?
    commune.category.users.include?(user)
  end

  def modifiable_by?(user)
    return true if commune.users.include?(user)
    return false if self.locked?
    self.user_id == user.id
  end
  # }}}

  #def favourite?(user)
  #  return false if user.is_a?(AnonymousUser)
  #  user.favourites.include?(self.id)
  #end

  def poll?
    choices_count > 0
  end

end

class Reply < Message
  belongs_to  :topic, :counter_cache => true
  #default_scope :order => 'created_at ASC'

  validates_presence_of :topic
  validates_associated  :pictures
  delegate  :locked, :to => :topic
  #delegate              :title, :to => :topic
  #delegate              :commune, :to => :topic

  # Access control {{{
  def creatable_by?(user)
    return false if topic.locked?
    return true if topic.commune.category.public?
    topic.commune.category.users.include?(user)
  end

  def viewable_by?(user)
    return true if topic.commune.category.public?
    return false unless user.active?
    topic.commune.category.users.include?(user)
  end

  def modifiable_by?(user)
    return false if topic.locked?
    return true if topic.commune.users.include?(user)
    self.user.id == user.id
  end
  # }}}

  def poll?
    return false
  end

end

class PrivateMessage < Message
  belongs_to :receiver, :class_name => 'User',
    :foreign_key => 'receiver_id',
    :counter_cache => :received_private_messages_count
  belongs_to :sender, :class_name => 'User'

  attr_accessible :receiver_id, :title

  def modifiable_by?(user)
    return true if self.user_id == user.id or self.receiver_id == user.id
    return false
  end

end
