# Module which can perform basic operations on 1D data arrays

module Dsp::DataProperties

    extend self 

    def all_maxima(data)
        # all_maxima(data: Array) returns all maximum in an array of `OpenStruct`s with #index and #value
        raise ArgumentError.new("Data must be an array") if not data.is_a? Array
        slope = Slope::Positive
        max = []
        data.each_with_index do |n, i|
            old_slope = slope
            if i <= data.length - 2
                new_slope = find_slope(data[i], data[i+1])
                slope = new_slope.is?(:zero) ? old_slope : new_slope
                max << OpenStruct.new(index: i, value: n) if old_slope.is? :positive and slope.is? :negative
            else
                max << OpenStruct.new(index: i, value: n) if slope.is? :positive
            end
        end
        max
    end

    def maxima(data, num = 1)
        # maxima(data: Array, num = 1: Integer) returns `num` number of largest maxima from the data array returned in #all_maxima
        all_maxima(data).sort{ |a, b| b.value <=> a.value }.take num
    end

    def local_maxima(data, num=1)
        # local_maxima(data: Array, num=1: Integer) calculates all maxima and orders them by how much proportionally they
        # are to any directly adjacent maxima. It then takes `num` answer and returns an array of `OpenStruct`s with #index and #value
        # This is particularly useful to use when looking for local maxima in a FFT dB or magnitude plot.
        all_maxima = all_maxima(data)
        all_maxima.sort do |a, b|
            a_upper = all_maxima.find{ |maxima| maxima.index > a.index }
            a_lower = all_maxima.reverse.find{ |maxima| maxima.index < a.index }
            a_adjacent = 0
            if a_upper && a_lower
                a_adjacent = ((a.value.to_f / a_upper.value) + (a.value.to_f / a_lower.value))  / 2.0
            else
                a_adjacent = !!a_upper ? (a.value.to_f / a_upper.value) : (a.value.to_f / a_lower.value)
            end
            b_upper = all_maxima.find{ |maxima| maxima.index > b.index }
            b_lower = all_maxima.reverse.find{ |maxima| maxima.index < b.index }
            b_adjacent = 0
            if b_upper && b_lower
                b_adjacent = ((b.value.to_f / b_upper.value) +  (b.value.to_f / b_lower.value))  / 2.0
            else
                b_adjacent = !!b_upper ? (b.value.to_f / b_upper.value) : (b.value.to_f / b_lower.value)
            end
            b_adjacent <=> a_adjacent
        end
        .take(num)
    end

    def slope(a,b, range=1)
        # slope(a: Numeric, b: Numeric, range=1: Numeric ) returns the slope of these two y values, given a change in x values by `range` which defualts to 1. Returns a float
        return (b - a) / range.to_f
    end

    def find_slope(a,b)
        # find_slope(a: Int or Double, b: Int or Double) returns Slope::Positive, Slope::Negative, or Slope::Zero
        # Note: Slope::Positive.is? :positive returns true, Slope::Negative.is? :negative returns true, etc.
        slope = nil
        if b - a > 0
            slope = Slope::Positive
        elsif b - a < 0
            slope = Slope::Negative
        else
            slope = Slope::Zero
        end
        slope
    end

    ## Inner slope class made for pleasant syntax in the maxima methods
    class Slope
        def self.Negative
            Negative
        end

        def self.Positive
            Positive
        end

        def self.Zero
            Zero
        end

        class Negative
            def self.type
                :negative
            end

            def self.==(val)
                if val.respond_to? :type
                    return true if val.type == :negative
                end
                return true if val == :negative
                if val.respond_to? :downcase
                    return true if val.downcase == "negative"
                end
                false
            end

            def self.is?(val)
                self.==(val)
            end
        end

        class Positive
            def self.type
                :positive
            end

            def self.==(val)
                if val.respond_to? :type
                    return true if val.type == :positive
                end
                return true if val == :positive
                if val.respond_to? :downcase
                    return true if val.downcase == "positive"
                end
                false
            end

            def self.is?(val)
                self.==(val)
            end
        end

        class Zero
            def self.type
                :zero
            end

            def self.==(val)
                if val.respond_to? :type
                    return true if val.type == :zero
                end
                return true if val == :zero
                if val.respond_to? :downcase
                    return true if val.downcase == "zero"
                end
                false
            end

            def self.is?(val)
                self.==(val)
            end
        end
    end
end