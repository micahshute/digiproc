module Dsp::Functions

    extend Convolvable::ClassMethods
    include Dsp::DataProperties

    def self.cross_correlation(data1, data2)
        self.conv(data1, data2.reverse)
    end

end