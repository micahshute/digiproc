##
# O(n*lgn) FFT algorithm
# Requires that the number of datapoints be a power of 2
# if it isn't the calculation will zero pad to the closest 
# power of 2 above the current data size
# The size of the outputted DFT will be the size of the zero-padded
# dataset. Zero-padding causes the "sample locations" of the DFT to
# be at different locations than if it was not zero padded, but 
# The resolution of the DFT will INCREASE due to zero padding
class Digiproc::Strategies::Radix2Strategy 

    E = Math::E
    PI = Math::PI

    attr_reader :data

    ##
    # == Initialize Arg
    # data (Optional):: Array[Numeric] (defaults to nil)
    def initialize(data = nil)
        @data = data
        zero_fill if not data.nil?
    end

    ## 
    # == Input arg
    # data (Optional):: Array[Numiric] (defaults to @data)
    def calculate(data = @data)
        recursive_fft(data)
    end

    # @data writer, and zero fills array to 
    # obtain a size of the closest power of 2 above current size
    def data=(data)
        @data = data
        zero_fill
    end

    private

    def recursive_fft(arr)
        n = arr.length
        return arr if n == 1
        w_n = E ** ((-2 * PI * Complex(0,1)) / n)
        w = 1
        a0 = get_even(arr)
        a1 = get_odd(arr)
        y0 = recursive_fft(a0)
        y1 = recursive_fft(a1)
        y = Array.new(n, 0)
        for k in 0...(n/2) do
            y[k] = (y0[k] + w * y1[k])
            y[k + n/2] = (y0[k] - w * y1[k])
            w = w * w_n
        end
        y
    end

    def get_even(arr)
        even = []
        arr.each_with_index { |a, i| even << a.dup if i % 2 == 0 }
        even
    end

    def get_odd(arr)
        odd = []
        arr.each_with_index { |a, i| odd << a.dup if i % 2 == 1 }
        odd
    end

    def zero_fill
        len = self.data.length
        @data = @data.concat Array.new(closest_pow_of_2(len) - len, 0)
    end

    def power_of_two?(num)
        lg = Math.log(num,2)
        lg.round.to_f == lg 
    end

    def closest_pow_of_2(num)
        2 ** Math.log(num,2).ceil
    end
end