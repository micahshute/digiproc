##
# Class for generating random numbers from a Gaussin Population
# of a given mean or standard deviation
class Dsp::Strategies::GaussianGeneratorBoxMullerStrategy
    
    ##
    # No input args
    # Returns 2 random numbers from a gaussain population with 
    # stddev of 1 and mean of 0
    def self.rand2
        uniform_random = Random.new
        r = (-2 * Math.log(1 - uniform_random.rand)) ** 0.5
        theta = 2 * Math::PI * (1 - uniform_random.rand)
        return r * Math.cos(theta), r * Math.sin(theta)    
    end

    attr_accessor :mean, :stddev

    ## 
    # == Input Args:
    # mean (Optional):: Numeric (default 0)
    # stddev (Optional):: Numeric (default 1)
    def initialize(mean = 0, stddev = 1)
        @mean, @stddev = mean, stddev
        @needs_gen = true
        @next = nil
    end

    # Get a single random number from a Gaussian distribution with a 
    # mean and stddev as defined by @mean and @stddev
    # Use the .rand2 method to get 2 random numbers. Save one, return the other
    def rand
        if @needs_gen
            x,y = self.class.rand2
            @next = y
            @needs_gen = false
            return self.mean + self.stddev * x
        else
            @needs_gen = true
            return self.mean + self.stddev * @next
        end
    end

    # Calls the .rand2 method
    def rand2
        self.class.rand2
    end

end