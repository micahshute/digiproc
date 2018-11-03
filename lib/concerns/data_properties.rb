module Dsp::DataProperties

    #returns Array of OpenStruct with #index and #value
    #currently returns maxima as well as positive inflections
    def self.all_maxima(data)
        raise ArgumentError.new("Data must be an array") if not data.is_a? Array
        slope = find_slope(data[0], data[1])
        max = []
        data.each_with_index do |n, i|
            old_slope = slope
            max << OpenStruct.new(index: i, value: n) if i == 0 and slope.is :negative
            if i <= data.length - 2
                slope = find_slope(data[i], data[i+1])
                max << OpenStruct.new(index: i, value: n) if old_slope.is :positive and not slope.is :positive
            else
                max << OpenStruct.new(index: i, value: n) if slope.is :positive
            end
        end
        max
    end

    def self.maxima(data, num = 1)

    end

    def self.find_slope(a,b)
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

            def self.is(val)
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

            def self.is(val)
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

            def self.is(val)
                self.==(val)
            end
        end
    end
end