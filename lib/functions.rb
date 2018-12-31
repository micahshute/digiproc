module Dsp::Functions

    extend Convolvable::ClassMethods, FourierTransformable::GenericMethods, Dsp::DataProperties

    def self.cross_correlation(data1, data2)
        self.conv(data1, data2.reverse)
    end

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

    def self.map_to_eqn(starting_min, starting_max, target_min, target_max)
        target_center = center_of(target_max, target_min)
        target_range = range_of(target_max, target_min)
        starting_center = center_of(starting_max, starting_min) 
        starting_range = range_of(starting_max.to_f, starting_min)
        range_map = target_range.to_f / starting_range
        ->(n){ (n - starting_center) * range_map + target_center}
    end

    #Arguents are X-dimensional ponins as array => optional hash value for probability
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

    def self.center_of(max, min)
        (max + min) / 2.0
    end

    def self.range_of(max, min)
        max.to_f - min
    end

    def self.zeros(num)
        Array.new(num, 0)
    end
    
    def self.ones(num)
        Array.new(num, 1)
    end
    
    def self.linspace(start, stop, number)
        rng = 0...number
        interval = (stop - start).to_f / (number - 1)
        rng.map{ |val| start + interval * val }
    end

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

    def self.monotonic?(data)
        !!monotonic_state(data)
    end

    def self.bin_str_to_i(bin_str)
        str_arr = bin_str.split("").reverse
        sum = 0
        str_arr.each_with_index do |digit, index|
            sum += digit.to_i * 2 ** index
        end
        sum
    end

    def self.str_xor(str1, str2)
        bin_str_to_i(str1) ^ bin_str_to_i(str2)
    end

    

    @fact_memo = {}

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

    def self.sinc(x)
        return 1 if x == 0
        Math.sin(x) / x.to_f
    end 
    
    def self.process(values, eqn)
        values.map{ |val| eqn.call(val) }
    end

end