##
# Class to calculate probabilities based off of a gaussian distributed random variable. 
class Dsp::Probability::TheoreticalGaussianDistribution

    attr_reader :mean, :stddev, :variance
    
    def initialize(mean: , stddev: , generator_strategy: Dsp::Strategies::GaussianGeneratorBoxMullerStrategy)
        @mean, @stddev = mean, stddev
        @variance = stddev ** 2
        @generator_strategy = generator_strategy.new(mean, stddev)
    end

    ## 
    # Return the cdf [Float] of an input x [Float]
    ## gd = Dsp::Probability::TheoreticalGaussianDistribution.new(mean: 0, stddev: 1)
    ## gd.cdf(0.3) # => 0.6179114221889526
    def cdf(x)
        1 - q(x)
    end

    ##
    # Return the q value [Float] of an input x [Float]
    ## gd = Dsp::Probability::TheoreticalGaussianDistribution.new(mean: 0, stddev: 1)
    ## gd.q(0.3) # => 0.3820885778110474
    def q(x)
        xform_x = xform_x_to_standard(x)
        0.5 * Math.erfc(xform_x  / (2 ** 0.5))
    end

    ##
    # Return the probability [Float] of the random variable being between an upper [Float] and lower [Float] value 
    ## gd = Dsp::Probability::TheoreticalGaussianDistribution.new(mean: 0, stddev: 1)
    ## gd.p_between(-1, 1) # => 0.6826894921370859
    def p_between(lower, upper)
        cdf(upper) - cdf(lower)
    end

    ##
    # Return the probability [Float] of the random variable being outside an upper [Float] and lower [Float] value 
    ## gd = Dsp::Probability::TheoreticalGaussianDistribution.new(mean: 0, stddev: 1)
    ## gd.p_outside(-1, 1) # => 0.31731050786291415
    def p_outside(lower, upper)
        cdf(lower) + q(upper)
    end

    ##
    # Outputs a single random number from the gaussian distribution
    ## gd.rand # => 1.4173209026395848
    def rand
        @generator_strategy.rand
    end

    
    private

    def xform_x_to_standard(x)
        (x - self.mean) / self.stddev.to_f
    end
end