##
# Module supplying probability functions 
module Dsp::Probability

    ##
    # Interchangable strategy
    #Strategy requirements: 
        #can be initialized with no arguments (gives mean = 0 and stddev = 1), or with a mean and stddev
        #instance method: #rand returns normal distribution with mean = 0, stddev = 1
    @gaussian_generator = Dsp::Strategies::GaussianGeneratorBoxMullerStrategy.new


    ##
    # Returns a new instance of a normal number random generator, which contains an instance method #rand which will return a 
    # single random number from the normal distribution
    # == Arguments
    # mean:: [Float] mean of the distribution defaults to 0
    # stddev:: [Float] standard deviation of the distribution defaults to 1
    ## gen = Dsp::Probability.normal_random_generator(100, 15) # => return rand gen of IQ scores
    ## scores = []
    ## 10.times do 
    ##    scores << gen.rand
    ## end
    ## puts scores # => [98.22222989456891, 102.78474153867536, 130.32345913801984, 90.68720464516447, 94.45065665514275, 100.46571157090098, 105.40955807686252, 85.9616084359681, 103.05219341559669, 96.62475435904693]
    def self.normal_random_generator(mean = 0, stddev = 1)
       @gaussian_generator.class.new(mean, stddev)
    end

    ##
    # == Arguments
    # size:: [Integer] number of returns expected, defaults to 1
    # If `size` is 1, returns a single number from the distribution
    # For `size` > 1, return an array of numbers from the distribution
    ## Dsp::Probability.nrand(5) # => [-0.4870987490684469, 0.48974360810927925, -0.3722088483576355, -0.2829898781247938, 0.12540113064787742]
    ## Dsp::Probability.nrand # => 0.7978655621417761
    def self.nrand(size = 1)
        return @gaussian_generator.rand if size == 1
        rand_nums = []
        size.times do 
            rand_nums << @gaussian_generator.rand
        end
        return rand_nums
    end

    ##
    # Returns [Float] the mean of the inputted data
    # == Arguments
    # data:: [Array] data to be evaluated
    ## dat = [4,12,19,4,8,9]
    ## Dsp::Probability.mean(dat) # => 9.333333333333334
    def self.mean(data)
        data.sum / data.length.to_f
    end

    ##
    # Returns [Float] the variance of the inputted data
    # == Arguments
    # data:: [Array] data to be evaluated
    # variance = sum_over_datavals( (dataval - mean) ^ 2 ) / (number_of_datavals - 1)
    ## dat = [4,12,19,4,8,9]
    ## Dsp::Probability.variance(dat) # => 31.866666666666664
    def self.variance(data)
        mu = mean(data)
        summation = data.map{ |val| (val - mu) ** 2 }.sum
        summation.to_f / (data.length - 1)
    end

    ## 
    # Returns [Float] the variance of inputted data for a stationary process
    # (stationary proces = mean, variance, autocorrelation do not change with time)
    # Will run faster over large datasets because each val in data is not undergoing a subtraction with mu
    # If the process is not stationary, an incorrect result with be given
    # == Arguments
    # data:: [Array] data to be evaluated
    # stat_var = sum_over_datavals( val^2 ) / number_ov_vals
    ## dat = [4,12,19,4,8,9]
    ## Dsp::Probability.stationary_variance(dat) # => 26.555555555555543
    def self.stationary_variance(data)
        mu = mean(data)
        summation = data.map{ |val| val ** 2 }.sum
        (summation.to_f / data.length) - (mu ** 2)
    end

    ##
    # Returns [Float] the standard deviation of the inputted data
    # == Arguments 
    # data:: [Array] data to be evaluated
    # stddev = sqrt(variance)
    ## dat = [4,12,19,4,8,9]
    ## Dsp::Probability.stddev # => 5.645056834671079
    def self.stddev(data)
        variance(data) ** (0.5)
    end
 

    ##
    # Returns [Float] the covariance (if process is stationary) of two datasets
    # == Arguments
    # data1:: [Array] first dataset
    # data2:: [Array] second datatset
    ## dat = [4,12,19,4,8,9]
    ## dat2 = [19, 20, 35, 15, 13, 17]
    ## Dsp::Probability.stationary_covariance(dat, dat2) # => 31.22222222222223

    def self.stationary_covariance(data1, data2)
        raise ArgumentError.new("Datasets must be of equal length") if data1.length != data2.length
        xcs = data1.dot data2
        mu1 = mean(data1)
        mu2 = mean(data2)
        (xcs / (data1.length.to_f)) - (mu1 * mu2) 
    end

    ##
    # Returns [Float] covariance of two datasets
    # == Arguments
    # data1:: [Array] first dataset
    # data2:: [Array] second datatset
    ## dat = [4,12,19,4,8,9]
    ## dat2 = [19, 20, 35, 15, 13, 17]
    ## Dsp::Probability.ovariance(dat, dat2) # => 37.46666666666667
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

    ##
    # Calculates Pearson's correlation coefficient of two datasets
    # == Arguments
    # data1:: [Array] first dataset
    # data2:: [Array] second dataset
    ## dat = [4,12,19,4,8,9]
    ## dat2 = [19, 20, 35, 15, 13, 17]
    ## Dsp::Probability.correlation_coefficient(dat, dat2) # => 0.84450000297225
    ## cdat = [1,2,3,4,5]
    ## ddat = cdat.map{ |v| v * -29 }
    ## Dsp::Probability.correlation_coefficient(cdat, ddat) # => -1.0
    def self.correlation_coefficient(data1, data2)
        covar = covariance(data1, data2)
        var1 = variance(data1)
        var2 = variance(data2)
        return covar.to_f / ((var1 ** 0.5) * (var2 ** 0.5))
    end

    ##
    # Alias for #variance
    def self.var(d)
        variance(d)
    end

    ##
    # Alias for #covariance
    def self.cov(d1, d2)
        covariance(d1,d2)
    end

    ##
    # Alias for #correlation_coefficient
    def self.corr_coeff(d1, d2)
        correlation_coefficient(d1, d2)
    end

    ##
    # Returns the error function output [Float] of the input ie:
    # For an input x and a normal distribution with mean 0 and variance 0.5, it is the probability a random variable will be between -x and x
    # Mirrors Math.erf(x)
    # == Arguments
    # x:: [Float] 
    ## Dsp::Prbobability.erf(0.3) # => 0.32862675945912734
    def self.erf(x)
        Math.erf(x)
    end

    ##
    # Returns the erfc [Float] per Math.erfc
    # For an input x and a normal distribution with mean 0 and variance 0.5, it is the probability a random variable will not be between -x and x
    # == Arguments
    # x:: [Float] 
    ## Dsp::Prbobability.erfc(0.3) # => 0.6713732405408727
    def self.erfc(x)
        Math.erfc(x)
    end

    ##
    # Returns [Float] probability that a random variable from a normal distribution of a certain mean and standard deviation will be less than a value x
    # == Arguments
    # x:: [Float] the value which the probability will be evaluated that a random variable will be below
    # mean:: [Float] the mean of the normal distribution (defaults to 0)
    # stddev:: [Float] the standard deviation of the normal distribution (defaults to 1)
    ## Dsp::Probability.normal_cdf(0.5) # =>  0.691462461274013
    ## Dsp::Probability.normal_cdf(140, 100, 15) # => 0.9961696194324102 
    def self.normal_cdf(x, mean = 0, stddev = 1)
        1 - normal_q(x, mean, stddev)
    end

    ##
    # Returns [Float] the probability that a random variable from a normal distribution of a certain mean and standard deviation will be greater than a value x
    # == Arguments
    # x:: [Float] the value which the probability will be evaluated that a random variable will be below
    # mean:: [Float] the mean of the normal distribution (defaults to 0)
    # stddev:: [Float] the standard deviation of the normal distribution (defaults to 1)
    ## Dsp::Probability.normal_q(0.5) # =>  0.30853753872598694
    ## Dsp::Probability.normal_cdf(140, 100, 15) # => 0.0038303805675897395
    def self.normal_q(x, mean = 0, stddev = 1)
        xformed_x = (x - mean) / stddev.to_f
        0.5 * erfc(xformed_x / (2 ** 0.5))
    end

    ##
    # Returns [Hash] the discrete probability distribution function of an inputted array of values
    # == Arguments
    # data:: [Array] discrete values in a dataset
    ## dat = [3,3,4,5,4,5,6,5,6,5,7,6,5,4]
    ## Dsp::Probability.pdf(dat) # => {3=>2, 4=>3, 5=>5, 6=>3, 7=>1}
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