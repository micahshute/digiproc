class RectangularWindow < WindowStrategy
    def initialize(size: )
        super(size: size)
        calculate
    end

    def find_size(freq)
        size = 0.9 / freq
        make_odd(size.ceil)
    end

    def transition_width
        0.9 / @size
    end
end