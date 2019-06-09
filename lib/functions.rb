##
# Contains many class methods which perform useful functions 
module Dsp::Functions

    extend Dsp::Convolvable::ClassMethods, Dsp::FourierTransformable::GenericMethods, Dsp::DataProperties

    ##
    # Performs cross correlation cacluatlino for two arrays of numerics
    def self.cross_correlation(data1, data2)
        self.conv(data1, data2.reverse)
    end

    ##
    # Maps an array of numerics to a range defined by a min and max
    # Output an array of samples mapped to within the bounds of the min and max
    # == Input args
    # samples:: Array of Numerics
    # min:: Float, the minimum desired value of the new mapped data
    # max:: Float, the maximum desired value of the new mapped data
    def self.map_data_to_range(samples, min, max)
        target_center = (max + min) / 2.0
        target_range = max.to_f - min
        smax, smin = samples.max, samples.min
        sample_center = (smax + smin) / 2.0
        sample_range = smax.to_f - smin
        center_map = target_center - sample_center 
        range_map = target_range / sample_range
        mapping = ->(n){ (n + center_map) * range_map }
        process(samples, mapping)
    end

    ##
    # Return a lambda equation which will map a dataset within a starting min and max to a 
    # new dataset with a different min and max.
    # == Input Args
    # starting_min:: Float, minimum val of data to be mapped
    # starting_max:: Float, maximum val of data to be mapped
    # target_min:: Float, minimum value of data after mapping
    # target_max:: Float, maximum value of data after mapping
    def self.map_to_eqn(starting_min, starting_max, target_min, target_max)
        target_center = center_of(target_max, target_min)
        target_range = range_of(target_max, target_min)
        starting_center = center_of(starting_max, starting_min) 
        starting_range = range_of(starting_max.to_f, starting_min)
        range_map = target_range.to_f / starting_range
        ->(n){ (n - starting_center) * range_map + target_center}
    end

    ##
    # == Input args
    # *args:: Can be a variable number of Floats, an array, or a hash with key value pairs of point locations with the value of probability values
    # If a variable number of floats are an array of floats are given, they will be treated as points on a 1-dimentional line and the return will
    # be an array of numbers which are the sampe points centered around the origin .
    # If a hash is given, the keys will be assumed to be places on the 1D line and the values will be the corresponding probabilities of those points.
    # The same calculation will be carried out, except taking inot account the appropriate weighting.
    # Note: Arguents are X-dimensional ponins as array => optional hash value for probability
    def self.translate_center_to_origin(*args)
        args = args[0] if args.length == 1 and args.first.is_a? Enumerable
        points = []
        probabilities = []
        dimensions = 0
        if args.is_a? Hash 
            args.each do |k,v|
                points << k
                probabilities << v
            end
        else
            points = args
            probabilities = points.map{ 1.0 / points.length }
        end
    
        if probabilities.include?(nil)
            probabilities.map{ 1.0 / points.length }
        end
        dimensions = points.first.length
        weighted_points = points.map.with_index do |point, index|
            point.map{|dimension| -1 * dimension * probabilities[index]}
        end
        a = weighted_points.reduce(Array.new(dimensions,0), :plus)
        points.map{ |vector| vector.plus(a) }
    end

    ##
    # Return the center of a max and min point
    # == Input args
    # max:: float
    # min:: float
    def self.center_of(max, min)
        (max + min) / 2.0
    end

    ##
    # Return the range of a max and min point
    # == Input args
    # max:: float
    # min:: float
    def self.range_of(max, min)
        max.to_f - min
    end

    ##
    # Return an arary of zeros of length num
    # == Input args
    # num:: Integer
    def self.zeros(num)
        Array.new(num, 0)
    end
    
    ##
    # Return an array of ones of length numn
    # == Input args
    # num:: Integer
    def self.ones(num)
        Array.new(num, 1)
    end
    
    ##
    # Similar to linspace in numpy, return an array of numbers given a min, max, and total number 
    # of elements
    # == Input args
    # start:: flaot, the minimum number and index 0 of the output array
    # stop:: float, the maximum number and last index of the output array
    # number:: integer, the number of elements in the output array
    def self.linspace(start, stop, number)
        rng = 0...number
        interval = (stop - start).to_f / (number - 1)
        rng.map{ |val| start + interval * val }
    end

    ##
    # Given an array of numerics, if it is monitonic (ie flat, increaseing, or decreasing), return
    # a symbol representing its state. Return nil of the data is not monotonic
    # == Input args
    # data:: Array[Numeric]
    def self.monotonic_state(data)
        last_value = data.first
        state = [:flat, :increasing, :decreasing]
        state_index = 0
        for i in 1...data.length do
            return state[state_index] if state[state_index].nil? 
            slope = data[i] - last_value
            if slope > 0
                state_index = 1 if state[:state_index] == :flat
                return nil if state[:state_index] != :increasing
            elsif slope < 0
                state_index = 2 if state[:state_index] == :flat
                return nil if state[:state_index] != :decreasing
            end
            last_value = data[i]
        end
        return state[:state_index]
    end

    ##
    # Return true or false based on if the data is monotoic (ie has a consistant slope direction)
    # ==Input Arg
    # data:: Array[Numeric]
    def self.monotonic?(data)
        !!monotonic_state(data)
    end

    ##
    # Transform a binary number represented in string form into an integer
    # == Input Arg
    # bin_str:: String
    ## Dsp::Functions.bin_str_to_i("101101") # => 45
    def self.bin_str_to_i(bin_str)
        str_arr = bin_str.split("").reverse
        sum = 0
        str_arr.each_with_index do |digit, index|
            sum += digit.to_i * 2 ** index
        end
        sum
    end

    ##
    # XOR two strings representing binary numbers, return the XOR of them in decimal
    ## Dsp::Functions.str_xor("1011","1001") # => 2
    def self.str_xor(str1, str2)
        bin_str_to_i(str1) ^ bin_str_to_i(str2)
    end

    

    @fact_memo = {}

    ##
    # Given a number, return its factorial
    def self.fact(n)
        raise ArgumentError.new("n must be positive") if n < 0
        return 1 if n <= 1
        return @fact_memo[n] if not @fact_memo[n].nil?
        x = n * fact(n - 1)
        @fact_memo[n] = x
        return x
    end

    # def self.populate_large_factorial_memoization
    #     for i in 1..10 do 
    #         fact(10000 * i)
    #     end 
    # end

    ##
    # Return the value of sinc(x), given an input x (float)
    # sinc = sin(x) / x
    def self.sinc(x)
        return 1 if x == 0
        Math.sin(x) / x.to_f
    end 
    
    ##
    # Maps values using the lambda equation
    # == Input args
    # values:: Collection of values
    # eqn:: lambda 
    def self.process(values, eqn)
        values.map{ |val| eqn.call(val) }
    end

end