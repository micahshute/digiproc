class Dsp::Probability::TheoreticalBinomialDistribution

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
        n_fact = Functions.fact(self.n)
        k_fact = Functions.fact(k)
        n_fact / (k_fact * (Math.fact(self.n - k)))
    end

    
end

