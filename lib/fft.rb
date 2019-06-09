##
# Class to calculate and store the Discrete Fourier Transform of a siugnal
class Dsp::FFT

    ##
    # Calculate the FFT of given time data
    # == Input arg
    # time_data:: Array[Numeric]
    def self.calculate(time_data)
        Radix2Strategy.calculate(time_data)
    end

    ##
    # Calculate the IFFT of the given frequency data
    # Input frequency data, perform the Inverse FFT to populate the time data
    # == Input arg
    # data:: Array[Numeric]
    def self.new_from_spectrum(data)
        time_data = Dsp::Strategies::IFFTConjugateStrategy.new(data)
        new(freq_data: data, time_data: time_data)
    end

    # Reader for @data
    # Allows for lazy calculation of @data (which holds frequency domain data)
    # If @data is nil, the #calculate method will be called
    def data
        calculate if @data.nil?
        @data
    end

    attr_accessor :strategy, :window, :processed_time_data, :time_data_size, :inverse_strategy
    include Dsp::Convolvable::InstanceMethods, Dsp::Plottable::InstanceMethods


    ##
    # == Input Args
    # strategy:: FFT Strategy, see Dsp::Strategies::Radix2Strategy to see required Protocol
    # time_data:: Array[Numeric] time data to be transformed to the frequency domain via the FFT strategy
    # size (Optional):: Integer, defaults to nil. If not set, your data will be zero padded to the closest higher power of 2 (for Radix2Strategy), or not changed at all
    # window (Optional):: Dsp::Window, defaults to Dsp::RectangularWindow. Changes the window used during #process_with_window method
    # freq_data (Optional):: Array[Niumeric], required if time_data not given
    # inverse_strategy (Optional):: Dsp::Strategies::IFFTConjugateStrategy is the default value and shows the required protocol
    # Note: Using size with a Radix2Strategy will only ensure a minimum amount of 
    # zero-padding, it will mostly likely not determine the final size of the time_data
    # You need to have EITHER time_data or freq_data, but not both.
    def initialize(strategy: Dsp::Strategies::Radix2Strategy, time_data: nil, size: nil, window: Dsp::RectangularWindow, freq_data: nil, inverse_strategy: Dsp::Strategies::IFFTConjugateStrategy)
        raise ArgumentError.new("Either time or frequency data must be given") if time_data.nil? and freq_data.nil?
        raise ArgumentError.new('Size must be an integer') if not size.nil? and not size.is_a?(Integer) 
        raise ArguemntError.new('Size must be greater than zero') if not size.nil? and size <= 0 
        raise ArgumentError.new('time_data must be an array') if not time_data.respond_to?(:calculate) and not time_data.is_a? Array
        
        if time_data.is_a? Array
            @time_data_size = time_data.length
            if not size.nil?
                if size <= time_data.length
                    @time_data = time_data.dup.map{ |val| val.dup }.take(size)
                else 
                    zero_fill = Array.new(size - time_data.length, 0)
                    @time_data = time_data.dup.map{ |val| val.dup }.concat zero_fill
                end
            else
                @time_data = time_data.dup.map{ |val| val.dup}
            end
            @strategy = strategy.new(@time_data.map{ |val| val.dup})
            @window = window.new(size: time_data_size)
        else
            @time_data = time_data
            @strategy = strategy.new
            @window = window.new(size: freq_data.length)
        end
        @inverse_strategy = inverse_strategy
        @data = freq_data
    end

    ##
    # Performs FFT caclulation if not yet performed. Returns FFT data as an Array of Floats (or an array of Complex numbers)
    def calculate
        self.strategy.data = time_data if @strategy.data.nil?
        @fft = self.strategy.calculate
        @data = @fft
    end

    ##
    # Input argument of an Integer describing the required size of the FFT. IF using a strategy requiring a certain amount of 
    # data points (ie Radix2), you will be guaranteed tha the FFT is greater than or equal to the input size. Otherwise, your FFT will be this size
    def calculate_at_size(size)
        if size > self.data.size
            zero_fill = Array.new(size - @time_data.length, 0)
            @time_data = time_data.concat zero_fill
        elsif size < self.data.size
            @time_data = time_data.take(size)
        end
        self.strategy.data = time_data
        calculate
    end

    ##
    # Calculate the IFFT of the frequency data
    def ifft
        inverse_strategy.new(data).calculate
    end

    ##
    # Calculate the IFFT and return it as a Dsp::DigitalSignal
    def ifft_ds
        Dsp::DigitalSignal.new(data: ifft)
    end


    ##
    # Returns the time_data as an Array of Numerics (floats or Complex numbers)
    def time_data
        if @time_data.is_a? Array
            @time_data
        elsif @time_data.respond_to? :calculate
            @time_data = @time_data.calculate
        else
            raise TypeError.new("time_data needs to be an array or an ifft strategy, not a #{@time_data.class}")
        end
    end

    ##
    # Processes the time_data with the chosen window valuesand calculates the FFT based of of the window-processed time domain signals
    def process_with_window
        @processed_time_data = time_data.take(time_data_size).times self.window.values
        self.strategy.data = @processed_time_data
        @fft = self.strategy.calculate
        @data = @fft
    end

    ##
    # Returns the frequency domain data as an Array of Numerics (Float or Complex)
    def fft
        self.data
    end

    ##
    # Return the number of frequency domain datapoints
    def size
        self.data.length
    end

    ##
    # Return the magnitude of the frequency domain values as an array of floats
    def magnitude
        data.map do |f|
            f.abs
        end
    end

    ##
    # Return the complex conjugate of the frequency domain data, as an array of numerics (float or complex)
    def conjugate
        self.data.map(&:conjugate)
    end

    ##
    # Return the decible of the frequency domain data, as an Array of floats
    def dB
        self.magnitude.map do |m|
            Math.db(m)
        end
    end

    ##
    # Returns the angle of the frequency domain data, as an array of floats (in radians)
    def angle
        self.data.map(&:angle)
    end

    ##
    # Returns the real part of the frequency domain data, as an array of floats
    def real
        self.data.map(&:real)
    end

    ##
    # Returns the imaginary part of the frequency domain data, as an array of floats
    def imaginary
        self.data.map(&:imaginary)
    end

    ##
    # Returns the maximum value(s) of the magnitude of the frequency signal as an Array of  OpenStructs with 
    # an index and value property. 
    # == Input arg
    # num (Optional):: The number of maxima desired, defaults to 1
    def maxima(num = 1)
        Dsp::DataProperties.maxima(self.magnitude, num)
    end

    ##
    # Returns the local maximum value(s) of the  magnitude of the frequency signal as an Array of  OpenStructs with 
    # an index and value property. 
    # Local maxima are determined by Dsp::DataProperties.local_maxima, and the returned maxima are determined based off of 
    # their relative hight to adjacent maxima. This is useful for looking for spikes in frequency data
    # == Input arg
    # num (Optional):: The number of maxima desired, defaults to 1
    def local_maxima(num = 1)
        Dsp::DataProperties.local_maxima(self.magnitude, num)
    end

    ##
    # Allows multioplication of FFT objects with anything with a @data reader which holds an Array of Numerics.
    # The return value is a new FFT object whose frequency data is the element-by-element multiplication of the two data arrays
    def *(obj)
        if obj.respond_to?(:data) 
            return self.class.new_from_spectrum(self.data.times obj.data)
        elsif obj.is_a? Array 
            return self.class.new_from_spectrum(self.data.times obj)
        end
    end

    ##
    # Uses Plottable module to plot the db values
    def plot_db(path: "./") 
        self.plot(method: :dB, xsteps: 8, path: path) do |g|
            g.title = "Decibles"
            g.x_axis_label = "Normalized Frequency"
            g.y_axis_label = "Magnitude"
        end
    end

    ## 
    # uses Plottable module to plot the magnitude values
    def plot_magnitude(path: "./" )
        self.plot(method: :magnitude, xsteps: 8, path: path) do |g|
            g.title = "Magnitude"
            g.x_axis_label = "Normalized Frequency"
            g.y_axis_label = "Magnitude"
        end
    end


    ##
    # TODO: Remove
    # plots magnitude using Gruff directly
    def graph_magnitude(file_name = "fft")
        if @fft
            g = Gruff::Line.new
            g.data :fft, self.magnitude
            g.write("./#{file_name}.png")
        end
    end

    ##
    # TODO: Remove
    # Plots time data using Gruff directly
    def graph_time_data
        g = Gruff::Line.new
        g.data :data, @time_data
    end


end