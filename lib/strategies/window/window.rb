##
# Parent class to all types of windows

class Digiproc::WindowStrategy

    PI = Math::PI


    attr_accessor :size
    attr_reader :values, :equation, :data

    # Initialize with size: Numeric (numnber of datapoints in window)
    def initialize(size: )
        @size = size
        @equation = lambda { |n| 1 }
    end

    ##
    # No input args
    # calculate the window values 
    def calculate
        values = []
        for n in 0...size
            values << @equation.call(n)
        end
        @values = values
        @data = values
    end

    #
    # Make the number of datapoints in the window odd so that 
    # it can be used for all types of filters
    def make_odd(num)
        num.odd? ? num : num + 1
    end

    # Return window values as a Digiproc::DigitalSignal
    def to_signal
        Digiproc::DigitalSignal.new(data: values)
    end

end