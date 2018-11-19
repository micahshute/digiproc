module FourierTransformable

    module GenericMethods

        def fft_strategy
            Radix2Strategy
        end

        def ifft_strategy
            Dsp::Strategies::IFFTConjugateStrategy
        end

        def fft(data)
            fft_strategy.new(data.dup).calculate
        end

        def ifft(data)
            ifft_strategy.new(data.dup).calculate
        end

    end

    def self.included(base)
        base.class_eval do 
            include RequiresData
        end
    end

    attr_writer :fft
    attr_reader :fft_strategy

    def initialize(time_data: , fft_strategy: Radix2Strategy)
        @fft_strategy = Radix2Strategy
        @fft = Dsp::FFT.new(time_data: time_data.dup, strategy: fft_strategy)
    end

    def fft_db
        setup_fft
        @fft.fft.db
    end

    def fft_magnitude
        setup_fft
        @fft.magnitude
    end

    def fft(size = @fft.data.size)
        if @fft.data.size != size
            @fft.calculate_at_size(size)
        end
        @fft
    end

    def fft_strategy=(strategy)
        @fft.strategy = strategy
    end

    def fft_data
        setup_fft
        @fft.fft
    end

    def fft_angle
        setup_fft
        @fft.angle
    end

    def fft_real
        setup_fft
        @fft.real
    end

    def fft_imaginary
        setup_fft
        @fft.fft.imaginary
    end

    private

    def setup_fft
        self.fft.calculate if self.fft.fft.nil?
    end

end