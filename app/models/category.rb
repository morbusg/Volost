class Category < ActiveRecord::Base
  attr_accessible :title, :public
  acts_as_list

  has_many :groups
  has_many :users, :through => :groups
  has_many :communes, :dependent => :destroy, :order => :position

  validates_presence_of   :title
  validates_uniqueness_of :title

  #default_scope :order => :position
  named_scope :public, :conditions => { :public => true }

  # Access control {{{
  def creatable_by?(user)
    # ...
    return false
  end

  def modifiable_by?(user)
    # ...
    return false
  end

  def viewable_by?(user)
    return true if public?
    return false unless user.active?
    users.include?(user)
  end
  # }}}

end
