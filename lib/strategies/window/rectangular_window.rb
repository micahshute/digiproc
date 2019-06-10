##
# A basic ReactangularWindow used when making a digital filter
class Digiproc::RectangularWindow < Digiproc::WindowStrategy

    # Initialize with a size: Integer
    # Number of datapoints
    def initialize(size: )
        super(size: size)
        calculate
    end

    # Find the size given an input frequency in rad/s
    def find_size(freq)
        size = 0.9 / freq
        make_odd(size.ceil)
    end

    # Return the transition width based on the @size
    def transition_width
        0.9 / @size
    end
end