class HammingWindow < WindowStrategy
    def initialize(size: nil , norm_trans_freq: nil)
        super(size: norm_trans_freq.nil? ? size : find_size(norm_trans_freq))
        size = @size + 2
        @equation = lambda { |n| 0.54 - 0.46 * Math.cos(2 * PI * (n + 1) / (size - 1)) }
        calculate
        @values = @values.take(@size)
    end

    def find_size(freq)
        size = 3.3 / freq
        make_odd(size.ceil)
    end

    def transition_width
        3.3 / @size
    end
end
