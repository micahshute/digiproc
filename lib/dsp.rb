require "dsp/version"

module Dsp

    extend Convolvable::ClassMethods

    def self.cross_correlation(data1, data2)
        self.conv(data1, data2.reverse)
    end

  
end
