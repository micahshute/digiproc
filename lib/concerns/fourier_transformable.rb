module FourierTransformable

    def self.included(base)
        base.class_eval do 
            include RequiresData
        end
    end

    attr_accessor :fft_strategy, :fft

    def initialize(data: , fft_strategy: Radix2Strategy)
        @fft_strategy = Radix2Strategy
        @fft = Dsp::FFT.new(data: data.dup)
    end

end