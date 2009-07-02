class Choice < ActiveRecord::Base
  belongs_to  :topic, :counter_cache => true
  has_many    :votes
  has_many    :users, :through => :votes

  def blank?
    description.blank?
  end
end
