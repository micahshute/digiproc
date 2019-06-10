##
# Class for performing actions on Digital Signals easily
class Digiproc::DigitalSignal
    attr_accessor :data
    include Digiproc::Convolvable::InstanceMethods, Digiproc::FourierTransformable

    ##
    # Construct an instance from a Proc (or a Lambda) and a size
    ## ds = Digiproc::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
    def self.new_from_eqn(eqn: , size: )
        rng = (0...size)
        self.new(data: rng.map{ |n| eqn.call(n) })
    end

    ##
    # Make a digital signal which is defined by one equation in one range, and another eqn in another range
    ## eqn1 = ->(t){ (1 - Math::E ** (-0.08*t)) } 
    ## eqn2 = ->(t){ Math::E ** (-0.002*(t - 100)) }
    ## ds = Digiproc::DigitalSignal.new_from_equations(eqns: [eqn1, eqn2], ranges: [0...100, 100...1000])
    def self.new_from_equations(eqns: , ranges: )
        data = []
        eqns.each_with_index do |eqn, i|
            ranges[i].each do |n|
                data[n] = eqn.call(n)
            end
        end
        data.map!{ |val| val.nil? ? 0 : val }
        self.new(data: data)
    end
    

    ##
    # Make a new digital signal from fft data
    def new_from_spectra(fft)
        self.new(data: Digiproc::Functions.ifft(fft))
    end
    
    ##
    # Initialize with `data`
    def initialize(data: )
        raise ArgumentError.new("Data must be an Array, not a #{data.class}") if not data.is_a? Array
        @data = data
        initialize_modules(Digiproc::FourierTransformable => {time_data: data})
    end

    ##
    # Helper method to allow user to process a ds data using a block
    ## ds = Digiproc::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
    ## ds.process { |el| el * 10 } # Change signal gain from 1 to 10.
    # Does not change @data, just returns processed array
    def process 
        processed_data = []
        for i in 0...data.length do
            processed_data << (yield data[i])
        end
        processed_data
    end

    ##
    # Same as `#process` except @data is replaced by the output
    def process!
        processed_data = []
        for i in 0...data.length do
            processed_data << (yield data[i])
        end
        self.data = processed_data
    end

    ##
    # Updates data while processing, allowing recursive processing (ie using prev outputs to create new ones)
    def process_in_place!
        for i in 0...data.length do 
            self.data[i] = yield data[i]
        end
        self.data
    end

    ##
    # Allows multiplication of two digital signal objects
    # Performs element by element multiplicaiton of the data vectors
    def *(ds)
        raise ArgumentError.new("Object must have a data property") unless ds.respond_to? :data
        raise ArgumentError.new("Object must have a data array") unless ds.data.respond_to? :times
        self.data.length < ds.data.length ? self.class.new(data:self.data.times(ds.data.take(self.data.length))) : self.class.new(data: ds.data.times(self.data.take(ds.data.length))) 
        # self.data.times ds.data
    end

    ##
    # Get data values from @data by index
    ## ds = Digiproc::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
    ## vals = ds.i(10..12) # => [-0.5440211108893699, -0.9999902065507035, -0.5365729180004349]
    def i(*n)
        indices = n.map{ |input| input.respond_to?(:to_a) ? input.to_a : input}
        indices.flatten!
        indices.map!{ |val| self.value_at val }
        return indices.length == 1 ? indices.first : indices
    end

    ##
    # Get the value at a specific data index. If index falls outside of the `data` array, return 0 
    # This is useful when simulating a signal multiplied by a unit step which is zero outside the bounds defined in the data array
    def value_at(n)
        data[n].nil? ? 0 : data[n]
    end

    ##
    # Get values in the data array from a start index to a start index (inclusive). Does not turn data outside array into a 0 value
    def values_between(start,stop)
        data[start, stop - start + 1]
    end

    ##
    # Convolves data with incoming signal, returns a new Digiproc::DigitalSignal whose data is the result of the convolution
    def ds_convolve(signal)
        Digiproc::DigitalSignal.new(data: self.conv(signal))
    end

    ##
    # Alias to ds_convolve
    def ds_conv(signal)
        Digiproc::DigitalSignal.new(data: self.conv(signal))
    end

    ## 
    # Performs cross correlation with an incoming signal, returns a Digiproc::DigitalSignal whose data is the result of the cross correlation
    def ds_cross_correlation(signal)
        Digiproc::DigitalSignal.new(data: self.cross_correlation(signal))
    end

    ##
    # Alias for #ds_cross_correlation
    def ds_xcorr(sig)
        ds_cross_correlation(sig)
    end

    ##
    # Performs an autocorrelation of the `data` array and retursn a Digiproc::DigitalSignal whose data is the result of the autocorrelation
    def ds_auto_correlation
        Digiproc::DigitalSignal.new(data: self.auto_correlation)
    end

    ##
    # Alias to #ds_auto_correlation
    def ds_acorr
        ds_auto_correlation
    end

    ##
    # Returns the Power Spectral Density (PSD) of the signal by multiplying the signal's FFT by the conjugate of the FFT (ie squaring the FFT)
    # The result is in the frequency spectrum (as a Digiproc::FFT object)
    def power_spectral_density
        self.fft * self.fft.conjugate
    end

    ##
    # Alias to #power_spectral_density
    def psd
        self.power_spectral_density
    end

    ##
    # Returns the cross_spectral_density of the digital signal with an incoming signal (accepts an array of numeric data)
    # Returns a Digiproc::FFT object 
    def cross_spectral_density(signal)
        ft = Digiproc::FFT.new(time_data: self.xcorr(signal))
        ft.calculate
        ft
    end

    ##
    # Alias for #cross_spectral_density
    def csd(signal)
        self.cross_spectral_density(signal)
    end

    ##
    # Returns data as an array
    def to_a
        self.data
    end
end