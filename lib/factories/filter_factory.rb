##
# Factory for different filters. 
# Filters are created using the Windowing method
# The window for the filter outputted will depend on the required stopband attenuation


class Dsp::Factories::FilterFactory

    ##
    # == Give requirements of the filter:
    # type:: Accepts: 'highpass', 'lowpass', 'bandpass', 'bandstop'
    # wc:: cutoff frequency in radians
    # wo:: center frequency in radians
    # bw:: bandwidth in radians
    # transition_width:: in NORMALIZED FREQUENCY, ie 0 to 1 scale, where 1 = Sampling Frequency (should be changed to rad for consistency)
    # stopband_attenuation:: level of stopband in decibles
    #  
    # == Also Note:
    # Dsp::LowpassFilter:: requires wc, not wo or bw
    # Dsp::HighpassFilter:: requires wc, not wo or bw
    # Dsp::BandpassFilter:: requires wo and bw, not wc
    # Dsp::BandstopFilter:: requires wo and bw, not wc
    # NOTE: This factory makes all sizes odd in ensure all types of filters will work (ie an even number of values will not allow a highpass filter, an anti-symmetric odd will not allow a lowpass, etc.)
    # Available windows: Dsp::RectangularWindow, Dsp::HanningWindow, Dsp::HammingWindow, Dsp::BlackmanWindow
    def self.filter_for(type: , wc: nil, wo: nil, bw: nil, transition_width: nil, stopband_attenuation: )
        window = nil
        size = 0
        if stopband_attenuation < 21
            window = Dsp::RectangularWindow
            size = make_odd(0.9 / transition_width)
        elsif stopband_attenuation < 40
            window = Dsp::HanningWindow
            size = make_odd(3.1 / transition_width)
        elsif stopband_attenuation < 50
            window = Dsp::HammingWindow
            size = make_odd(3.3 / transition_width)
        else
            window = Dsp::BlackmanWindow
            size = make_odd(5.5 / transition_width)
        end

        case type.to_s.downcase
        when 'lowpass'
            return Filters::lowpass.new(wc: wc, size: size, window: window)
        when 'highpass'
            return Filters::highpass.new(wc: wc, size: size, window: window)
        when 'bandpass'
            return Filters::bandpass.new(wo: wo, bw: bw, size: size, window: window)
        when 'bandstop'
            return Filters::bandstop.new(wo: wo, bw: bw, size: size, window: window)
        else
            raise ArgumentError.new('Filter types include: lowpass, highpass, bandpass, bandstop')
        end
    end

    ##
    # Input Numeric, output closest round integer >= to input 
    def self.make_odd(num)
        n = num.round 
        n += 1 if n.even?
        n
    end

    # An unnecessary inner class that Dsp::Factories::FilterFactory uses. Only a wrapper to Dsp::XXXXXFilter
    class Filters        
        def self.lowpass
            Dsp::LowpassFilter
        end

        def self.highpass
            Dsp::HighpassFilter
        end

        def self.bandpass
            Dsp::BandpassFilter
        end

        def self.bandstop
            Dsp::BandstopFilter
        end
    end

end