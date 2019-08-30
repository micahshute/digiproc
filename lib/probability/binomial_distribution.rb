##
# Allows you to solve problems whose probabilities are dictated by a binomial distribution
# Does not simulate a problem, but calculates probabilities based off of the binomial distribution equation
# See examples/binomial_distribution/dice.rb

class Digiproc::Probability::TheoreticalBinomialDistribution

    attr_accessor :n, :k, :p

    ##
    # == Initialize with n, k, and p
    # n:: [Integer] Number of trials
    # k:: [Integer] (optional at initialization) Number of successes
    # p:: [Numeric] Probability of success
    def initialize(n: ,k: nil , p: )
        @n = n
        @k = k
        @p = p
    end

    ##
    # Returns the Expected Value of a binomial distributed random variable (n * p)
    ## bd = Digiproc::Probability::TheoreticalBinomialDistribution.new(n:10, p: 0.5)
    ## bd.expect # => 5
    # ie in above example, expect 5 successes (heads) in 10 flips of a coin
    def expect
        self.n * self.p
    end

    ##
    # Return the Variance of the binomial distributed random variable (n * p * (1 - p))
    # Using above example:
    ## bd.var # => 2.5
    def var
        self.n * self.p * ( 1 - self.p )
    end

    ##
    # Will run `probability` method using `self.k` 
    ## bd.k = 5
    ## bd.prob # => 0.24609375
    def prob
        self.probability(self.k)
    end 

    ##
    # Will run `coefficient` method using `self.k`
    ## bd.coeff # => 252.0
    def coeff
        coefficient(self.k)
    end

    ##
    # Calculates the probability of `k` number of `wins`
    # `k` can be an array or a range of numbers, a variable number of args, or a single integer (see example referenced above)
    # If k is more than one value, the probabilities will be summed together
    # For example:
    ## bd.probability(5) # => 0.24609375
    ## bd.probability(0..5) # => 0.623046875
    ## bd.probability(1,2,5,6) # => 0.5048828125
    ## bd.probability([0,1,2,3,4,5]) # => 0.623046875
    def probability(*k)
        sum = 0
        karr = k.map{ |val| val.respond_to?(:to_a) ? val.to_a : val}
        karr.flatten!
        karr.each do |k_val| 
            sum += self.coefficient(k_val) * ((self.p) ** (k_val)) * (1 - self.p) ** (n - k_val)
        end
        sum.to_f
    end

    ##
    # Returns the binomial equation coefficient for a given number of wins, ie returns n! / (k! * (n - k)!)
    # Can take an argument of `k`, which defaults to `self.k`
    # Returns a BigDecimal
    ## bd.coefficient(4) # => 210.0
    def coefficient(k = self.k)
        n_fact = BigDecimal(Digiproc::Functions.fact(self.n))
        k_fact = BigDecimal(Digiproc::Functions.fact(k))
        n_fact / (k_fact * BigDecimal((Digiproc::Functions.fact(self.n - k))))
    end

    
end

