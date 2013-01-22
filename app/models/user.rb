# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  persistence_token :string(100)
#  password          :string(40)
#  email             :string(100)
#  contact_email     :string(100)
#  role              :integer          default(1)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :contact_email, :email, :password, :password_confirmation, :persistence_token, :role, :hero, :hero_attributes

  has_one :hero, dependent: :destroy
  accepts_nested_attributes_for :hero

  email_regex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates :email, presence: true,
                    format: email_regex,
                    uniqueness: { case_sensitive: false }
                    
  validates :password, presence: true,
                       confirmation: true,
                       length: 6..40

  validates :password_confirmation, presence: true
end
