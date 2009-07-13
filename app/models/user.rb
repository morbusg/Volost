class User < ActiveRecord::Base
  attr_accessor :email, :website # inverse CAPTCHA honeypot
  attr_accessible :login, :password, :password_confirmation,
    :location, :signature, :birthday, :avatar_attributes, :time_zone
  acts_as_authentic do |c|
    c.validate_email_field = false
    #c.require_password_confirmation = false
    #c.ignore_blank_passwords = true
    #c.validate_password_field = false
  end

  before_create :honeypot
  after_create { |ud| ud.toggle!(:admin) and ud.toggle!(:active) if ud.id == 1 }
  before_save { |ud| ud.moderator = true if !ud.communes.empty? }

  markdown        :signature
  #serialize       :favourites

  def title
    login
  end

  # Scopes {{{
  named_scope :present, lambda {{:conditions => ['seen_at > ?', 15.minutes.ago]}}
  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active => false } do
    def activate
      each { |user| user.update_attribute(:active, true) }
    end
  end
  # }}}

  # Associations {{{
  has_many	:groups
  has_many	:categories, :through => :groups
  has_many  :communes, :through => :groups
  has_many	:messages, :dependent => :destroy, :order => 'created_at DESC'
  has_many  :topics
  has_many  :replies
  has_many  :sent_private_messages, :class_name => 'PrivateMessage'
  has_many  :received_private_messages, :class_name => 'PrivateMessage',
    :foreign_key => 'receiver_id'
  has_many	:pictures, :dependent => :destroy
  has_many  :votes
  has_many  :choices, :through => :votes
  has_one   :avatar
  accepts_nested_attributes_for :avatar
  # }}}

  # Validations {{{
  validates_length_of     :location, :maximum => 25
  validates_length_of     :signature, :maximum => 250
  # }}}

  # Access control {{{
  def modifiable_by?(user)
    return true if user.admin?
    return false if user.is_a?(AnonymousUser)
    self.id == user.id
  end

  def can_create?(resource)
    return true if self.admin?
    return false if self.is_a?(AnonymousUser)
    return false unless self.active?
    resource.creatable_by?(self)
  end

  def can_modify?(resource)
    return true if self.admin?
    resource.modifiable_by?(self)
  end

  def can_view?(resource)
    return true if self.admin?
    resource.viewable_by?(self)
  end
  # }}}

  protected

  # The email and website fields are hidden for css-enabled and text browsers,
  # so to fill those in is to be a (likely) bot.
  def honeypot
    bot = true if !email.blank? or !website.blank?
  end

end

class AnonymousUser #< User
  def can_view?(resource)
    resource.viewable_by?(self)
  end
  def can_create?(resource)
    return false
    #resource.creatable_by?(self)
  end
  def can_modify?(resource)
    return false
    #resource.modifiable_by?(self)
  end
  def active?
    return false
  end
  def admin?
    return false
  end
  def record
    return self
  end
end
