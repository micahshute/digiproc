## 
# Module which can perform basic operations on 1D data arrays
# This module extends itself so all methods can be called via:
## Dsp::DataProperties.method_i_want_to_call

module Dsp::DataProperties

    extend self 
    ##
    ## all_maxima(data [Array]) => returns Array(OpenStruct<#index, #value>)
    # returns all maximum in an array of `OpenStruct`s with #index and #value, ie:
    ## all_maxima([1,2,3,4,5,4,3,2,6,7,8,7,6,5])   # [#<OpenStruct index=4, value=5>, #<OpenStruct index=10, value=8>] 
    def all_maxima(data)
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

    ##
    # maxima(data [Array], num = 1 [Integer]) returns `num` number of largest maxima from the data array returned in #all_maxima
    ## arr = [1,2,3,4,5,4,3,2,6,7,8,7,6,5]
    ## Dsp::DataProperties.maxima(arr, 1) # => [#<OpenStruct index=10, value=8>]
    def maxima(data, num = 1)
        all_maxima(data).sort{ |a, b| b.value <=> a.value }.take num
    end

    ##
    # local_maxima(data [Array], num=1 [Integer]) => returns Array(OpenStruct(#index, #value))
    # calculates all maxima and orders them by how much proportionally they
    # are to any directly adjacent maxima. It then takes `num` answer and returns an array of `OpenStruct`s with #index and #value
    # This is particularly useful to use when looking for local maxima in a FFT dB or magnitude plot.
    ##  arr = [50,45,40,30,35,30,29,28,29,20,15,10,19,9,8,7,9,8,7,6,5,9,6,5,4,9,6,3,2,7,5,4,3,2,1,9,1,2,3,4]
    ##  Dsp::DataProperties.local_maxima(arr, 3)  #=> [#<OpenStruct index=35, value=9>, #<OpenStruct index=0, value=50>, #<OpenStruct index=12, value=19>]
    def local_maxima(data, num=1)
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

    ##
    # slope(a: Numeric, b: Numeric, range=1: Numeric ) => float
    # returns the slope of these two y values, given a change in x values by `range` which defualts to 1. Returns a float
    ## Dsp::DataProperties.slope(0.5, 1.2, 0.5) #=> 1.4
    def slope(a,b, range=1)
        return (b - a) / range.to_f
    end

    ##
    # find_slope(a: Int or Double, b: Int or Double) returns Slope::Positive, Slope::Negative, or Slope::Zero
    # Note: Slope::Positive.is? :positive returns true, Slope::Negative.is? :negative returns true, etc.
    def find_slope(a,b)
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

    ##
    ## Inner slope class made for pleasant syntax in the maxima methods
    class Slope

        ##
        # returns inner class Negative
        def self.Negative
            Negative
        end

        ##
        # returns inner class Positive
        def self.Positive
            Positive
        end

        ##
        # returns inner class Zero
        def self.Zero
            Zero
        end

        ##
        ## Used in the Slope class to indicate a negative slope. 
        # Made for easy syntax purposes
        class Negative

            ##
            # Used for comparison in == 
            # returns :negative
            def self.type
                :negative
            end

            ##
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Negative == OpenStruct.new(type: :negative) # true
            ## Dsp::DataProperties::Slope::Negative == :negative # true
            ## Dsp::DataProperties::Slope::Negative == "negative" # true
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

            ##
            # Alias to ==
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Negative.is? OpenStruct.new(type: :negative) # true
            ## Dsp::DataProperties::Slope::Negative.is? :negative # true
            ## Dsp::DataProperties::Slope::Negative.is? "negative" # true, not case sensitive
            def self.is?(val)
                self.==(val)
            end
        end

        ##
        ## Used in the Slope class to indicate a positive slope. 
        # Made for easy syntax purposes
        class Positive
            def self.type
                :positive
            end

            ##
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Positive == OpenStruct.new(type: :positive) # true
            ## Dsp::DataProperties::Slope::Positive == :positive # true
            ## Dsp::DataProperties::Slope::Negative == "positive" # true, not case-sensitive
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

            ##
            # Alias to ==
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Piositive.is? OpenStruct.new(type: :negative) # true
            ## Dsp::DataProperties::Slope::Positive.is? :positive # true
            ## Dsp::DataProperties::Slope::Positive.is? "positive" # true, not case-sensitive
            def self.is?(val)
                self.==(val)
            end
        end

        ##
        ## Used in the Slope class to indicate a zero slope. 
        # Made for easy syntax purposes
        class Zero
            def self.type
                :zero
            end

            ##
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Zero == OpenStruct.new(type: :zero) # true
            ## Dsp::DataProperties::Slope::Zero == :zero # true
            ## Dsp::DataProperties::Slope::Zero == "zero" # true, not case sensitive
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

            ##
            # Alias to ==
            # Can test equality in multiple ways:
            ## Dsp::DataProperties::Slope::Zero.is? OpenStruct.new(type: :zero) # true
            ## Dsp::DataProperties::Slope::Zero.is? :zero # true
            ## Dsp::DataProperties::Slope::Zero.is? "zero" # true, not case sensitive
            def self.is?(val)
                self.==(val)
            end
        end
    end
end