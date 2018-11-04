module Dsp::Probability

    class BinomialDistribution

        attr_accessor :n, :k, :p
    
        def initialize(n: ,k: nil , p: )
            @n = n.to_f
            @k = k.to_f
            @p = p.to_f
        end
    
    
        def expect
            self.n * self.p
        end
    
        def var
            self.n * self.p * ( 1 - self.p )
        end
    
        def prob
            self.probability(self.k)
        end 
    
        def coeff
            coefficient(self.k)
        end
    
    
        def probability(*k)
            sum = 0
            karr = k.map{ |val| val.respond_to?(:to_a) ? val.to_a : val}
            karr.flatten!
            karr.each do |k_val| 
                sum += self.coefficient(k_val) * ((self.p) ** (k_val)) * (1 - self.p) ** (n - k_val)
            end
            sum
        end
    
    
        def coefficient(k)
            n_fact = Math.fact(self.n)
            k_fact = Math.fact(k)
            n_fact / (k_fact * (Math.fact(self.n - k)))
        end
    
        
    end
    
    module Math
        @fact_memo = {}
    
        def self.fact(n)
            raise ArguemntError.new("n must be positive") if n < 0
            return 1 if n <= 1
            return @fact_memo[n] if not @fact_memo[n].nil?
            x = n * fact(n - 1)
            @fact_memo[n] = x
            return x
        end
    
        def self.populate_large_factorial_memoization
            for i in 1..10 do 
                fact(10000 * i)
            end 
        end
    
    end
    
end