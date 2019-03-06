## 
# Module for Classes which have a property `data` which we can take the Discrete Fourier Transform of.
# A class which wants to use methods outside of GenricMethods will also include Dsp::Initializable, and you have to use the appropriate methods in your class constructor if you want the Dsp::FFT class to be set up automatically
# You could manually set it up if your class sets up its own @fft property which is an instance of Dsp::FFT with the class' `data` passed in.
# See an example of this in action in Dsp::DigitalSignal initializer method. 
module Dsp::FourierTransformable

    ## 
    # Inner module for places where standalone functions are needed, not associated with a class which contains `data`. See Dsp::Functions for use
    module GenericMethods

        ##
        # Return a Fast Fourier Transform (FFT) strategy to be used for GenericMethods. Set to Dsp::Strategies::Radix2Strategy
        # It is important to note that the Radix2Strategy increases the size of the FFT return to the closest power of 2. 
        def fft_strategy
            Dsp::Strategies::Radix2Strategy
        end

        # Return an Inverse Fast Fourier Transform (IFFT) strategy to be used for GenericMethods. Set to Dsp::Strategies::IFFTConjugateStrategy 
        def ifft_strategy
            Dsp::Strategies::IFFTConjugateStrategy
        end

        ## 
        ## fft(data [Array of complex Numerics]) => returns Array of data corresponding to the FFT
        # Note that for the Radix2Strategy, the only time the return size will equal the input size is if the input size is a power of 2. 
        # Otherwise the return will be increased to the closest power of 2.
        ## Dsp::Functions.fft([1,2,3,4,5,6,7,8]) # => [
        ## # 36, 
        ## # (-4.0+9.65685424949238i),
        ## # (-4.000000000000001+4.0i),
        ## # (-4.000000000000002+1.6568542494923797i),
        ## # -4,
        ## # (-3.9999999999999996-1.6568542494923797i),
        ## # (-3.999999999999999-4.0i),
        ## # (-3.999999999999998-9.65685424949238i)]
       
        def fft(data)
            fft_strategy.new(data.dup).calculate
        end
        
        ##
        ## ifft(data [Array of complex Numerics])
        # Due to using the Radix2Strategy, the ifft will return the exact input if the input is a power of 2.
        # Otherwise, there will be trailing 0s. ie: 
        ## ft = Dsp::Functions.fft([1,2,3,4,5,6,7,8])
        ## Dsp::Functions.ifft(ft) # => [(1.0-0.0i),
        ##  # (2.0000000000000004-2.718345674301793e-16i),
        ##  # (3.0+4.440892098500626e-16i),
        ##  # (4.0+3.8285686989269494e-16i),
        ##  # (5.0-0.0i),
        ##  # (6.0-4.978996250514798e-17i),
        ##  # (7.0-4.440892098500626e-16i),
        ##  # (8.0-6.123233995736767e-17i)]
        ## ft = Dsp::Functions.fft([1,2,3,4,5])
        ## Dsp::Functions.ifft(ft) # => [(1.0-0.0i),
        ##  # (2.0+3.0616169978683836e-17i),
        ##  # (3.0-3.3306690738754696e-16i),
        ##  # (4.0+8.040613248383182e-17i),
        ##  # (5.0-0.0i),
        ##  # (0.0-1.9142843494634747e-16i),
        ##  # (0.0+3.3306690738754696e-16i),
        ##  # (0.0+8.040613248383182e-17i)]
        def ifft(data)
            ifft_strategy.new(data.dup).calculate
        end

    end

    ## 
    # Include Dsp::RequiresData when an instance is instantiated that includes Dsp::FourierTransformable because
    # methods require `data` (an array of Fourier Transformable data) to exist in the class
    def self.included(base)
        base.class_eval do 
            include Dsp::RequiresData, Dsp::Initializable
        end
    end

    attr_writer :fft
    attr_reader :fft_strategy

    ## 
    # Initialize with (time_data: [Array(Numeric)], fft_strategy: [optional, defaults to Dsp::Strategies::Radix2Strategy])
    # Upon instantiation, a new Dsp::FFT class is made with the data passed in as time_data.
    # NOTE this does not happen automatically upon instantiation of the class which includes this module. 
    # The class including this module will also include Dsp::Initializable, so you can initialize this module in the class' #initialize method as follows:
    ## class TestClass
    ##     include Dsp::FourierTransformable
    ##     
    ##     attr_accessor :data
    ##
    ##     def initialize(data: )
    ##        @data = data
    ##        initialize_modules(Dsp::FourierTransformable => {time_data: data})
    ##     end
    ## end
    ## 
    # Note that the calculation of the FFT itself is lazy and will not be calculated unless there is an 
    # attempt to access it or #calculate is called on @fft
    def initialize(time_data: , fft_strategy: Dsp::Strategies::Radix2Strategy)
        @fft_strategy = fft_strategy
        @fft = Dsp::FFT.new(time_data: time_data.dup, strategy: fft_strategy)
    end

    ##
    ## fft_db #=> Array of decible values of the magnitude of the FFT (Float, not complex)
    # Ensures the fft is calculated, and then returns the dB vals
    def fft_db
        setup_fft
        @fft.fft.db
    end

    ## fft_db #=> Array of values of the magnitude of the FFT (numeric, not complex)
    # Ensures the fft is calculated, and then returns the magnitude
    def fft_magnitude
        setup_fft
        @fft.magnitude
    end

    ##
    ## fft(size [optional Integer]) #=> returns Dsp::FFT instance
    # Will calculate the FFT if it has not yet been calculated
    # size is an optional parameter which allows you to delegate the size of the FFT to be calculated..
    # This is useful if you want a particular resolution of the frequency domain, or if you are trying to match
    # FFT sizes for calculation purposes. 
    def fft(size = @fft.data.size)
        if @fft.data.size != size
            @fft.calculate_at_size(size)
        end
        @fft
    end

    ##
    # setter for the FFT strategy
    def fft_strategy=(strategy)
        @fft.strategy = strategy
    end

    ##
    ## fft_data # => Array of FFT vals (complex Numeric)
    # Calculates the fft if not yet calculated, and returns the calculation
    def fft_data
        setup_fft
        @fft.fft
    end

    ##
    ## fft_data # => Array of angle vals (radians)
    # Calculate the fft if not yet calculated, and returns Arra of the angle data in radians
    def fft_angle
        setup_fft
        @fft.angle
    end

    ##
    ## fft_real # => Array of real vals
    # Calculate the fft if not yet calculated, and retun an Array of the real values
    def fft_real
        setup_fft
        @fft.real
    end

    ##
    ## fft_imaginary # => Array of imaginary vals
    # Calculate the fft if not yet calculated, and retun an Array of the imaginary values
    def fft_imaginary
        setup_fft
        @fft.fft.imaginary
    end

    private
    ##
    # Private method which calculates the fft 
    def setup_fft
        self.fft.calculate if self.fft.fft.nil?
    end

end