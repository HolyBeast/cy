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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
