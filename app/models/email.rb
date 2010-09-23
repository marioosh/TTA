class Email < ActiveRecord::Base
  belongs_to :email_template
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
end
