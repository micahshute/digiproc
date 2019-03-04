class Dsp::WindowStrategy

    PI = Math::PI


    attr_accessor :size
    attr_reader :values, :equation, :data

    def initialize(size: )
        @size = size
        @equation = lambda { |n| 1 }
    end

    def calculate
        values = []
        for n in 0...size
            values << @equation.call(n)
        end
        @values = values
        @data = values
    end

    def make_odd(num)
        num.odd? ? num : num + 1
    end

    def to_signal
        Dsp::DigitalSignal.new(data: values)
    end

end