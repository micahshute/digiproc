class Dsp::GaussianGeneratorBoxMullerStrategy

    def self.rand_2
        uniform_random = Random.new
        r = (-2 * Math.log(1 - uniform_random.rand)) ** 0.5
        theta = 2 * Math::PI * (1 - uniform_random.rand)
        return r * Math.cos(theta), r * Math.sin(theta)    
    end

end