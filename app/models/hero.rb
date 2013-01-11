# == Schema Information
#
# Table name: heros
#
#  id         :integer          not null, primary key
#  firstname  :string(12)
#  lastname   :string(17)
#  race       :string(255)
#  nation     :string(255)
#  sex        :string(1)
#  rank       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Hero < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :nation, :race, :rank, :sex
  belongs_to :user
end
