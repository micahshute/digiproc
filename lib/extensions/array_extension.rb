class Array

    def *(arr)
        raise ArgumentError.new("Array sizes must be equal") if self.size != arr.size
        output = []
        self.each_with_index do |o,i|
            output << o * arr[i]
        end
        output
    end

    
    def plus(arr)
        raise ArgumentError.new("sizes must be equal") if self.size != arr.size
        output = []
        self.each_with_index do |o,i|
            output << o + arr[i]
        end
        output
    end


end