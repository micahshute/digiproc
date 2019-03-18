##
# Factory class for Windows. Can output Dsp::HanningWindow, Dsp::HammingWindow, and Dsp::BlackmanWindow
# Decision made based off ofstopband_attenuation
## Dsp::Factories::WindowFactory.window_for(normalized_transition_width: 0.05, stopband_attenuation: 60) # => outputs Dsp::BlackmanWindow instance
class Dsp::Factories::WindowFactory

    def self.window_for(normalized_transition_width: , stopband_attenuation: )
        
        if stopband_attenuation < 40
            return Dsp::HanningWindow.new(norm_trans_freq: normalized_transition_width)
        elsif stopband_attenuation < 50
            return Dsp::HammingWindow.new(norm_trans_freq: normalized_transition_width)
        else
            return Dsp::BlackmanWindow.new(norm_trans_freq: normalized_transition_width)
        end
    end


end
