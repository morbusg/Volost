class Search < ActiveRecord::Base
  validates_presence_of :body
  def messages
    @messages = Message.all(:conditions => ["messages.body LIKE ? OR messages.title LIKE ?", "%#{body}%", "%#{body}%"],
                            :include => {:user => :avatar}).delete_if {|msg|
     msg.type == "PrivateMessage"} unless body.blank?
  end
   
end
