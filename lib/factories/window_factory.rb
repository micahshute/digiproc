##
# Factory class for Windows. Can output Digiproc::HanningWindow, Digiproc::HammingWindow, and Digiproc::BlackmanWindow

class Digiproc::Factories::WindowFactory

    ##
    # Decision made based off ofstopband_attenuation
    # @example
    # Digiproc::Factories::WindowFactory.window_for(normalized_transition_width: 0.05, stopband_attenuation: 60) # => outputs Digiproc::BlackmanWindow instance
    def self.window_for(normalized_transition_width: , stopband_attenuation: )
        
        if stopband_attenuation < 40
            return Digiproc::HanningWindow.new(norm_trans_freq: normalized_transition_width)
        elsif stopband_attenuation < 50
            return Digiproc::HammingWindow.new(norm_trans_freq: normalized_transition_width)
        else
            return Digiproc::BlackmanWindow.new(norm_trans_freq: normalized_transition_width)
        end
    end


end
