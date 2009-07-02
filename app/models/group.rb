class Group < ActiveRecord::Base
  belongs_to :category
  belongs_to :commune
  belongs_to :user
end
