module Dsp::DataProperties

    #returns Array of OpenStruct with #index and #value
    def self.all_maxima(data)
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

    def self.maxima(data, num = 1)
        all_maxima(data).sort{ |a, b| b.value <=> a.value }.take num
    end

    def self.local_maxima(data, num=1)
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