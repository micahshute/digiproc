class Dsp::Probability::TheoreticalGaussianDistribution

    attr_reader :mean, :stddev, :variance
    
    def initialize(mean: , stddev: , generator_strategy: Dsp::Strategies::GaussianGeneratorBoxMullerStrategy)
        @mean, @stddev = mean, stddev
        @variance = stddev ** 2
        @generator_strategy = generator_strategy.new(mean, stddev)
    end

    def cdf(x)
        1 - q(x)
    end

    def q(x)
        xform_x = xform_x_to_standard(x)
        0.5 * Math.erfc(xform_x  / (2 ** 0.5))
    end

    def p_between(lower, upper)
        cdf(upper) - cdf(lower)
    end

    def p_outside(lower, upper)
        cdf(lower) + q(upper)
    end

    def rand
        @generator_strategy.rand
    end

    
    private

    def xform_x_to_standard(x)
        (x - self.mean) / self.stddev.to_f
    end
end