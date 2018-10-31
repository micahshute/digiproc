class Dsp::WindowFactory

    attr_accessor :window

    def initialize(normalized_transition_width: , stopband_attenuation: )
        if stopband_attenuation < 40
            @window = HanningWindow.new(norm_trans_freq: normalized_transition_width)
        elsif stopband_attenuation < 50
            @window = HammingWindow.new(norm_trans_freq: normalized_transition_width)
        else
            @window = BlackmanWindow.new(norm_trans_freq: normalized_transition_width)
        end
    end

end
