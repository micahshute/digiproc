##
# Class for performing actions on Digital Signals easily
class Dsp::DigitalSignal
    attr_accessor :data
    include Dsp::Convolvable::InstanceMethods, Dsp::FourierTransformable

    ##
    # Construct an instance from a Proc (or a Lambda) and a size
    ## ds = Dsp::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
    def self.new_from_eqn(eqn: , size: )
        rng = (0...size)
        self.new(data: rng.map{ |n| eqn.call(n) })
    end

    ##
    # Make a digital signal which is defined by one equation in one range, and another eqn in another range
    ## eqn1 = ->(t){ (1 - Math::E ** (-0.08*t)) } 
    ## eqn2 = ->(t){ Math::E ** (-0.002*(t - 100)) }
    ## ds = Dsp::DigitalSignal.new_from_equations(eqns: [eqn1, eqn2], ranges: [0...100, 100...1000])
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
        self.new(data: Dsp::Functions.ifft(fft))
    end
    
    ##
    # Initialize with `data`
    def initialize(data: )
        raise ArgumentError.new("Data must be an Array, not a #{data.class}") if not data.is_a? Array
        @data = data
        initialize_modules(Dsp::FourierTransformable => {time_data: data})
    end

    ##
    # Helper method to allow user to process a ds data using a block
    ## ds = Dsp::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
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
    ## ds = Dsp::DigitalSignal.new_from_eqn(eqn: ->(t){ Math.sin(t) }, size: 100)
    ## vals = ds.i(10..12) # => [-0.5440211108893699, -0.9999902065507035, -0.5365729180004349]
    def i(*n)
        indices = n.map{ |input| input.respond_to?(:to_a) ? input.to_a : input}
        indices.flatten!
        indices.map!{ |val| self.value_at val }
        return indices.length == 1 ? indices.first : indices
    end

    def value_at(n)
        data[n].nil? ? 0 : data[n]
    end

    def values_between(start,stop)
        data[start, stop - start + 1]
    end

    def ds_convolve(signal)
        Dsp::DigitalSignal.new(data: self.conv(signal))
    end

    def ds_conv(signal)
        Dsp::DigitalSignal.new(data: self.conv(signal))
    end

    def ds_cross_correlation(signal)
        Dsp::DigitalSignal.new(data: self.cross_correlation(signal))
    end

    def ds_xcorr(sig)
        ds_cross_correlation(sig)
    end

    def ds_auto_correlation
        Dsp::DigitalSignal.new(data: self.auto_correlation)
    end

    def ds_acorr
        ds_auto_correlation
    end

    def power_spectral_density
        self.fft * self.fft.conjugate
    end

    def psd
        self.power_spectral_density
    end

    def cross_spectral_density(signal)
        ft = Dsp::FFT.new(time_data: self.xcorr(signal))
        ft.calculate
        ft
    end

    def csd(signal)
        self.cross_spectral_density(signal)
    end

    def to_a
        self.data
    end
end