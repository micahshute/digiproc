module Dsp::Probability

    #Interchangable strategy
    #Strategy requirements: 
        #can be initialized with no arguments (gives mean = 0 and stddev = 1), or with a mean and stddev
        #instance method: #rand returns normal distribution with mean = 0, stddev = 1
    @gaussian_generator = Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new


    def self.normal_random_generator(mean = 0, stddev = 1)
       @gaussian_generator.class.new(mean, stddev)
    end

    def self.nrand(size = 1)
        return @gaussian_generator.rand if size == 1
        rand_nums = []
        size.times do 
            rand_nums << @gaussian_generator.rand
        end
        return rand_nums
    end

    def self.mean(data)
        data.sum / data.length.to_f
    end

    def self.variance(data)
        mu = mean(data)
        summation = data.map{ |val| (val - mu) ** 2 }.sum
        summation.to_f / (data.length - 1)
    end

    def self.stationary_variance(data)
        mu = mean(data)
        summation = data.map{ |val| val ** 2 }.sum
        (summation.to_f / data.length) - (mu ** 2)
    end

    def self.stddev(data)
        variance(data) ** (0.5)
    end
 

    def self.stationary_covariance(data1, data2)
        raise ArgumentError.new("Datasets must be of equal length") if data1.length != data2.length
        xcs = data1.dot data2
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

    #Calculates Pearson's correlation coefficient
    def self.correlation_coefficient(data1, data2)
        covar = covariance(data1, data2)
        var1 = variance(data1)
        var2 = variance(data2)
        return covar.to_f / ((var1 ** 0.5) * (var2 ** 0.5))
    end

    def self.var(d)
        variance(d)
    end

    def self.cov(d1, d2)
        covariance(d1,d2)
    end

    def self.corr_coeff(d1, d2)
        correlation_coefficient(d1, d2)
    end

    def self.erf(x)
        Math.erf(x)
    end

    def self.erfc(x)
        Math.erfc(x)
    end

    def self.normal_cdf(x, mean = 0, stddev = 1)
        1 - normal_q(x, mean, stddev)
    end

    def self.normal_q(x, mean = 0, stddev = 1)
        xformed_x = (x - mean) / stddev.to_f
        0.5 * erfc(xformed_x / (2 ** 0.5))
    end

    def self.pdf(data)
        pdf = {}
        data.each do |datapoint|
            pt = datapoint.round(2)
            if pdf[pt].nil?
                pdf[pt] = 1
            else
                pdf[pt] += 1
            end
        end
        pdf
    end

    
end