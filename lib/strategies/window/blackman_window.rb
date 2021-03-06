## 
# Blackman Window
# Used to improve digital filters by using a non-retangular frequency domain window 
class Digiproc::BlackmanWindow < Digiproc::WindowStrategy

    ##
    # == Input Args
    # size (Optional):: Numeric (default: nil), how many datapoings the window should have
    # norm_trans_freq:: Numeric (default: nil), the desired transition frequency
    # If you know what size of the the window that you need, you can input size without norm_trans_freq
    # If you kow the desired transition frequency, the necessary size will be calculated for you based off of 
    # the window type so it is not necessary to enter the size
    def initialize(size: nil , norm_trans_freq: nil)
        super(size: norm_trans_freq.nil? ? size : find_size(norm_trans_freq))
        #size = @size + 2
        #@equation = lambda { |n| 0.42 - 0.5 * Math.cos(2 * PI * (n + 1) / (size - 1)) + 0.08 * Math.cos(4*PI*(n + 1) / (size - 1)) }
        @equation = lambda { |n| 0.42 - 0.5 * Math.cos(2 * PI * (n) / (size - 1)) + 0.08 * Math.cos(4*PI*(n) / (size - 1)) }
        calculate
        @values = @values.take(@size)
    end

    # Given a freqency, return the required size of a BlackmanWindow
    def find_size(freq)
        size = 5.5 / freq
        make_odd(size.ceil)
    end

    # Return the transition width (in rad/s) based off of the size
    def transition_width
        5.5 / @size
    end
end