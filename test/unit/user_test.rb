# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  pass          :string(40)
#  email         :string(100)
#  contact_email :string(100)
#  state         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
