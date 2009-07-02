class Commune < ActiveRecord::Base
  attr_accessible :title, :description, :category_id, :latest_id, :latest_page
  acts_as_list    :scope => :category

  belongs_to      :category
  belongs_to      :latest, :class_name => 'Message'
  has_many        :messages, :order => 'updated_at', :dependent => :destroy
  has_many        :topics, :order => 'sticky,updated_at DESC'
  has_many        :groups
  has_many        :users, :through => :groups

  validates_presence_of   :title
  validates_presence_of   :category
  validates_length_of     :title, :within => 4..40
  validates_uniqueness_of :title

  # Access control {{{
  def creatable_by?(user)
    # ...
    return false
  end

  def modifiable_by?(user)
    # ...
    users.include?(user)
  end

  def viewable_by?(user)
    # ...
    return true if category.public?
    return false unless user.active?
    category.users.include?(user)
  end
  # }}}

end
