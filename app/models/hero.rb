# encoding: utf-8
#
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

  SEX = %w( Homme Femme Autre )

  validates :firstname, :format => { with: /^[a-záàâäãåçéèêëíìîïñóòôöõúùûüýÿ]+$/i },
                        :length => { within: 3..12 },
                        :presence => true,
                        :uniqueness => { case_sensitive: false, scope: :lastname }

  validates :lastname, :format => { with: /^[a-záàâäãåçéèêëíìîïñóòôöõúùûüýÿ\x20'-]+$/i },
                       :length => { within: 3..18 },
                       :if => lambda { |hero| !hero.lastname.blank? }

  validates :nation, :presence => true,
                     :inclusion => { in: Nation::NAMES }

  validates :race, :presence => true,
                   :inclusion => { in: lambda do |hero|
                     Race::NAMES[hero.nation] ||= []
                     Race::NAMES[hero.nation]
                   end }

  validates :sex, :presence => true,
                  :inclusion => { in: self::SEX }
end
