module Dsp::CoreExtensions
    module ArrayExtension
        module DotProduct
            def dot(arr)
                raise ArgumentError.new("Array sizes must be equal") if self.size != arr.size
                output = []
                self.each_with_index do |o,i|
                    output << o * arr[i].conjugate
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

    module VectorExtension

        module Projection
            module ClassMethods
                def project(vec1, vec2)
                    vec1 = vec1.is_a?(Vector)? vec1 : Vector.elements(vec1)
                    vec2 = vec2.is_a?(Vector) ? vec2 : Vector.elements(vec2)
                    vec2.project_onto vec1
                end
            end
            module InstanceMethods
                def project_onto(vec)
                    raise ArgumentError.new("Argument must be a Vector") if not vec.is_a? Vector
                    (self.dot(vec) / (vec.r ** 2)) * vec
                end
            end
        end

    end


end