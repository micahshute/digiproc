module Dsp::Probability
    @gaussian_generator = nil

    def self.normal_random_generator(mean = 0, stddev = 1)
        Dsp::Strategies::GaussianGeneratorBoxMullerStrategy(mean, stddev)
    end

    def self.nrand
        @gaussian_generator = Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new if @gaussian_generator.nil? 
        @gaussian_generator.rand
    end

    def self.nrand2(mean, stddev, generator = Dsp::Strategies::GaussianGeneratorBoxMullerStrategy)    
        two_norms = generator.rand2
        first = mean + stddev * two_norms[0] 
        second = (mean + stddev * two_norms[1])
        return first, second
    end

    def self.mean(data)
        data.sum / data.length.to_f
    end

    def self.variance(data)
        mu = mean(data)
        summation = data.map{ |val| (val - mu) ** 2 }.sum
        (summation.to_f / (data.length - 1))
    end
 

    def self.stationary_covariance(data1, data2)
        raise ArgumentError.new("Datasets must be of equal length") if data1.length != data2.length
        xcs = (data1.dot data2).sum
        mu1 = mean(data1)
        mu2 = mean(data2)
        (xcs / (data1.length.to_f)) - (mu1 * mu2) 
    end

    def self.covariance(data1, data2)
        raise ArgumentError.new("Datasets must be of equal length") if data1.length != data2.length
        mu1 = mean(data1)
        mu2 = mean(data2)
        summation = 0
        for i in 0...data1.length do
            summation += ((data1[i] - mu1) * (data2[i] - mu2))
        end
        summation.to_f / (data1.length - 1)
    end

    def self.correlation_coefficient(data1, data2)
        covar = covariance(data1, data2)
        var1 = variance(data1)
        var2 = variance(data2)
        return covar.to_f / ((var1 ** 0.5) * (var2 ** 0.5))
    end


    
end