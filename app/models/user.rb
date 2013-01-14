# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  login         :string(20)
#  pass          :string(40)
#  email         :string(100)
#  contact_email :string(100)
#  state         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :contact_email, :email, :login, :pass, :pass_confirmation, :state, :hero, :hero_attributes

  has_one :hero, :dependent => :destroy
  accepts_nested_attributes_for :hero

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :login, :presence => true, 
                    :length => { :within => 4..25 }
  validates :pass, :confirmation => true
end
