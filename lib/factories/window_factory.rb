class Dsp::Factories::WindowFactory

    def self.window_for(normalized_transition_width: , stopband_attenuation: )
        
        if stopband_attenuation < 40
            return HanningWindow.new(norm_trans_freq: normalized_transition_width)
        elsif stopband_attenuation < 50
            return HammingWindow.new(norm_trans_freq: normalized_transition_width)
        else
            return BlackmanWindow.new(norm_trans_freq: normalized_transition_width)
        end
    end


end
