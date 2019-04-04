##
# Parent class to BandpassFilter, HighpassFilter, LowpassFilter, and BandstopFilter
class Dsp::DigitalFilter
    PI = Math::PI

    attr_accessor :size, :window, :fft, :weights

    ##
    # == Inputs
    # size:: [Integer] number of window datapoints
    # window:: [Dsp::WindowStrategy] 
    def initialize(size: , window: )
        #TODO: allow size to be even
        @size = size.even? ? size + 1 : size
        @window = window.new(size: size)
    end 

    ##
    # Ensures size is odd, and uses @equation to make a return Array of ideal filter values. 
    # Used by the child class to multiply by the window to the return value of this method for final weights
    def calculate_ideal
        #TODO: allow size to be even
        @size += 1 if @size.even?
        n_vals = ((-1 * (@size - 1) / 2)..((@size - 1) / 2)).to_a
        n_vals.map do |n|
            @equation.call(n)
        end
    end


    ##
    # Zero pad @weights  to achieve a size of the input value. 
    # set @fft to a new Dsp::FFT, and calculate with the new padded data.
    ## .set_fft_size(size [Integer])
    def set_fft_size(size)
        if size > @weights.length
            zeros = Array.new(size - @weights.length, 0)
            padded = @weights.concat(zeros)
            @fft = Dsp::FFT.new(data: padded)
            @fft.calculate
        end
    end

    ##
    # return a Dsp::DigitalSignal whose values are the weights of the filter
    def to_ds
        Dsp::DigitalSignal.new(data: self.weights)
    end

    #TODO: Inorder to implement, must separately recalculate for weight at n = 0
    # def shift_in_freq(normalized_freq)
    #     eqn = ->(n){ Math::E ** Complex(0, -1 * normalized_freq * n)}
    #     @weights = @weights.map.with_index do |w, i|
    #         w * eqn.call(i)
    #     end
    # end


end