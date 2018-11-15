
class Dsp::Factories::FilterFactory

    def self.filter_for(type: , wc: nil, wo: nil, bw: nil, transition_width: nil, stopband_attenuation: )
        window = nil
        size = 0
        if stopband_attenuation < 21
            window = RectangularWindow
            size = make_odd(0.9 / transition_width)
        elsif stopband_attenuation < 40
            window = HanningWindow
            size = make_odd(3.1 / transition_width)
        elsif stopband_attenuation < 50
            window = HammingWindow
            size = make_odd(3.3 / transition_width)
        else
            window = BlackmanWindow
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

    def self.make_odd(num)
        n = num.round 
        n += 1 if n.even?
        n
    end

    class Filters        
        def self.lowpass
            LowpassFilter
        end

        def self.highpass
            HighpassFilter
        end

        def self.bandpass
            BandpassFilter
        end

        def self.bandstop
            BandstopFilter
        end
    end

end