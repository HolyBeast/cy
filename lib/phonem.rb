module Phonem
  class String < String
    attr_accessor :string

    @@leet_letters = { '0' => 'o', '1' => 'i', '2' => 'z', '3' => 'e', '4' => 'a', '5' => 's', '6' => 'g', '7' => 't', '8' => 'b' }

    def initialize attributes = {}
      @string = attributes[:string]
    end

    def group

    end

    def phonem
      @string.gsub('/[' + @@leet_letters.keys.join + ']/', @@leet_letters)
    end
  end
end

p = Phonem::String.new(:string => 'Lul1n')
puts p.phonem