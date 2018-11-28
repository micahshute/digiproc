class DigitalFilter
    PI = Math::PI

    attr_accessor :size, :window, :fft, :weights

    def initialize(size: , window: )
        #TODO: allow size to be even
        @size = size.even? ? size + 1 : size
        @window = window.new(size: size)
    end 

    
    def calculate_ideal
        #TODO: allow size to be even
        @size += 1 if @size.even?
        n_vals = ((-1 * (@size - 1) / 2)..((@size - 1) / 2)).to_a
        n_vals.map do |n|
            @equation.call(n)
        end
    end


    def set_fft_size(size)
        if size > @weights.length
            zeros = Array.new(size - @weights.length, 0)
            padded = @weights.concat(zeros)
            @fft = Dsp::FFT.new(data: padded)
            @fft.calculate
        end
    end

    def to_ds
        DigitalSignal.new(data: self.weights)
    end

    #TODO: Inorder to implement, must separately recalculate for weight at n = 0
    # def shift_in_freq(normalized_freq)
    #     eqn = ->(n){ Math::E ** Complex(0, -1 * normalized_freq * n)}
    #     @weights = @weights.map.with_index do |w, i|
    #         w * eqn.call(i)
    #     end
    # end


end