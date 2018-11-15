module Dsp::CoreExtensions
    module ArrayExtension
        module DotProduct
            def dot(arr)
                raise ArgumentError.new("Array sizes must be equal") if self.size != arr.size
                output = []
                self.each_with_index do |o,i|
                    output << o * arr[i]
                end
                output.sum
            end
        end
        module Sum
            def plus(arr)
                raise ArgumentError.new("sizes must be equal") if self.size != arr.size
                output = []
                self.each_with_index do |o,i|
                    output << o + arr[i]
                end
                output
            end
        end

        module Multiply
            def times(arr)
                raise ArgumentError.new("Array sizes must be equal") if self.size != arr.size
                output = []
                self.each_with_index do |o,i|
                    output << o * arr[i]
                end
                output
            end
        end    
    end

    module MathExtension
        module Decible 
            def db(value)
                20 * Math.log(value, 10)
            end

            def db_power(value)
                10 * Math.log(value, 10)
            end

            def mag_from_db(decible)
                10 ** (decible / 20.0)
            end

            def power_from_db(decible)
                10 ** (decible / 10.0)
            end
        end
    end
end