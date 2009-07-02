class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :choice, :counter_cache => true
end
