class Radix2Strategy 

    E = Math::E
    PI = Math::PI

    attr_reader :data

    def initialize(data: )
        @data = data
        zero_fill
    end

    def calculate(data = @data)
        recursive_fft(data)
    end

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
            y[k] = y0[k] + w * y1[k]
            y[k + n/2] = y0[k] - w * y1[k]
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