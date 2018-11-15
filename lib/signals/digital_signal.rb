class DigitalSignal
    attr_accessor :data
    include Convolvable::InstanceMethods, Initializable, FourierTransformable

    
    def self.new_from_eqn(eqn: , size: )
        rng = (0...size)
        self.new(data: rng.map{ |n| eqn.call(n) })
    end

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
    
    def new_from_spectra(fft)
        Dsp::Functions.ifft(fft)
    end
    
    def initialize(data: )
        raise ArgumentError.new("Data must be an Array, not a #{data.class}") if not data.is_a? Array
        @data = data
        initialize_modules(FourierTransformable => {time_data: data})
    end

    def process 
        processed_data = []
        for i in 0...data.length do
            processed_data << (yield data[i])
        end
        processed_data
    end

    def fft(size)
        if @fft.data.size != size
            @fft.calculate_at_size(size)
        end
        @fft
    end

    def process!
        processed_data = []
        for i in 0...data.length do
            processed_data << (yield data[i])
        end
        self.data = processed_data
    end

    def process_in_place!
        for i in 0...data.length do 
            self.data[i] = yield data[i]
        end
        self.data
    end

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
        DigitalSignal.new(data: self.conv(signal))
    end

    def ds_conv(signal)
        DigitalSignal.new(data: self.conv(signal))
    end

    def ds_cross_correlation(signal)
        DigitalSignal.new(data: self.cross_correlation(signal))
    end

    def ds_xcorr(sig)
        ds_cross_correlation(sig)
    end

    def ds_auto_correlation
        DigitalSignal.new(data: self.auto_correlation)
    end

    def ds_acorr
        ds_auto_correlation
    end

    def power_spectral_density
        ft = Dsp::FFT.new(time_data: self.acorr)
        ft.calculate
        ft
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
end