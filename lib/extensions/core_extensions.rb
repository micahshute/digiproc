## 
# Add extensions to certain Ruby Classes for easy use of the library without using too many custom classes
module Dsp::CoreExtensions
    module ArrayExtension
        module DotProduct
            ##
            # Take the dot product of self another Array (allow complex numbers). They must be the same size. Returns a scalar
            ## myArray.dot(anotherArray) # => Float
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
            ##
            # Add two arrays element by element. They must be the same size
            ## myArray.plus(anotherArr) # => Array (same size as the input)
            def plus(arr)
                raise ArgumentError.new("sizes must be equal") if self.size != arr.size
                output = []
                self.each_with_index do |o,i|
                    output << o + arr[i]
                end
                output
            end
        end

        ##
        # Multiply two arrays element by element. They must be the same size
        ## myArray.times(anotherArr) => Array (same size as the input)
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

    # Extend functionaly of Ruby's Math module
    module MathExtension
        ##
        # Add methods which are useful when using decible values
        module Decible 
            ##
            ## db(numeric_input [Numeric]) # => returns 20 * Math.log(numeric_input, 10)
            def db(value)
                20 * Math.log(value, 10)
            end

            ##
            ## db_power(numeric_input [Numeric]) # => returns 10 * Math.log(numeric_input, 10)
            def db_power(value)
                10 * Math.log(value, 10)
            end

            ##
            # input a decible, recieve a magnitude
            def mag_from_db(decible)
                10 ** (decible / 20.0)
            end

            ##
            # Input a decible, recieve a magnitude (power)
            def power_from_db(decible)
                10 ** (decible / 10.0)
            end
        end
    end

    module VectorExtension
        ##
        # Extend functionality to Vector
        module Projection
            module ClassMethods
                ##
                # .projcect(vector1, vector2) returns a projection of vector 1 onto vector 2
                def project(vec1, vec2)
                    vec1 = vec1.is_a?(Vector)? vec1 : Vector.elements(vec1)
                    vec2 = vec2.is_a?(Vector) ? vec2 : Vector.elements(vec2)
                    vec2.project_onto vec1
                end
            end
            module InstanceMethods
                ##
                # .project_onto(vector) projects self onto the input vector
                def project_onto(vec)
                    raise ArgumentError.new("Argument must be a Vector") if not vec.is_a? Vector
                    (self.dot(vec) / (vec.r ** 2)) * vec
                end
            end
        end

    end

end