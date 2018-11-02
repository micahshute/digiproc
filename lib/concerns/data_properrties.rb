module DataProperties

    def maxima(data , num = 1)
        raise ArgumentError.new("Data must be an array") if not data.is_a? Array
        slope = data[1] - data[0] 
    end

    class Slope
        def self.Negative
            :negative
        end

        def self.Positive
            :positive
        end

        def self.Zero
            :zero
        end
    end
end