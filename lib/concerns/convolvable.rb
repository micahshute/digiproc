
module Dsp::Convolvable


    ## 
    # This module contains class methods for performing convolution based off a strategy. Dsp::Convolvable 
    # extends ClassMethods, and therefore all methods can be called on the Convolable module.
    # Note that arrays in this module must be of Numeric types
 
    module ClassMethods
        ## 
        ## convolve(data1 [Array], data2 [Array], strategy [ConvolutionStrategy]) => returns Array[Numeric]
        # This method performs convolution.
        # `strategy` can be custom-written as long as it matches the ConvolutionStrategy interface: 
        # have a class method called `conv` which takes 2 arrays and convolves them. ie: 
        ## Dsp::Convolvable.conv([1,2,3],[1,2,3]) #=> [1, 4, 10, 12, 9]

        def convolve(data1, data2, strategy = Dsp::Strategies::BFConvolutionStrategy)
            strategy.conv(data1, data2, strategy)
        end

        ## 
        # Alias to #convolve
        def conv(data1, data2, strategy = Dsp::Strategies::BFConvolutionStrategy) 
            strategy.conv(data1,data2)
        end

        ## 
        ## cross_correlation(data1 [Array], data2 [Array]) => returns Array[Numeric]
        # Uses the #conv method to perform cross_correlation by reversing the second data set order
        # Does not accept a strategy as a third parameter
        ## Dsp::Convolvable.cross_correlation(arr1, arr2)
        def cross_correlation(data1, data2)
            conv(data1, data2.reverse)
        end

        ## 
        # Alias to #cross_correlation
        def xcorr(data1, data2)
            cross_correlation(data1, data2)
        end

        ## 
        ## auto_correlation(data [Array]) => returns Array[Numeric]
        # Uses the cross_correlation method to perform cross correlation of data on itself.
        ## Dsp::Convolvable.auto_correlation([1,2,3]) # => [3, 8, 14, 8, 3]
        def auto_correlation(data)
            cross_correlation(data, data)
        end


        ## 
        # Alias to #auto_correlation
        # ie: 
        ## Dsp::Convolvable.acorr([1,2,3]) # => [3, 8, 14, 8, 3]
        def acorr(data)
            cross_correlation(data, data)
        end

    end

    ## 
    # This module contains instance methods for classes which have properties of `data` which 
    # are arrays and can undergo convolution, correlation, cross-correlation, and autocorrelation (arrays must then be of Numerics). As such, if 
    # a class `includes` Convolvable::InstanceMethods, it is also including `Dsp::RequiresData` which ensures that the
    # class has a `data` property

    module InstanceMethods

        ## 
        # When included in a class, it automatically has that class include Dsp::RequiresData, because methods in this module require that there be a property called `data` which is an Array
        def self.included(base)
            base.class_eval do 
                include Dsp::RequiresData
            end
        end

        ## 
        # Optionally initializable with a `ConvolutionStrategy` (see `Dsp::Initializable`)
        # This snows up as new, but when using this code, :initialize will be called. This pattern is utilized in the Dsp::DigitalSignal class, and can be seen in its initializer.
        def initialize(strategy: Dsp::Strategies::BFConvolutionStrategy)
            @convolution_strategy = strategy
        end

        ## 
        ## convolve(incoming_data [Array [OR a class including Dsp::RequiresData]]) => returns Array[Numeric]
        # uses the `strategy` class to convolve the included class' data property with the array provided as an argument
        # ie if class DataHolder includes Convolavable::InstanceMethods, and you have two instances, d1 and d2, you can say: 
        ## d1.convolve(d2)
        # Or, if you have a 1D array of numerics in variable `my_data_arr` capable of convolving with d1.data, you can say:
        ## d1.convolve(my_data_arr) # returns array of data
        def convolve(incoming_data)
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data)
        end

        ## 
        # Alias to convolve
        def conv(incoming_data)
            self.convolve(incoming_data)
        end

        ## 
        # Used internally to ensure that if the class which includes this module is not `Initializable`, then a Convolution strategy will still be set
        # In this case, use Dsp::BFConvolutionStrategy
        def convolution_strategy
            @convolution_strategy.nil? ? Dsp::Strategies::BFConvolutionStrategy : @convolution_strategy
        end

        ## 
        ## cross_correlation(incoming_data [Array [OR a class extending Dsp::RequiresData]]) => returns Array[Numeric]
        # see #convolve for example of using an array or a Dsp::RequiresData. ie: 
        ## includingInstance.cross_correlation(array_data) # returns array of data
        def cross_correlation(incoming_data)
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data.reverse)
        end

        ## 
        # Alias to cross_correlation
        def xcorr(incoming_data)
            self.cross_correlation(incoming_data)
        end

        ## 
        ## auto_correlation() => returns Array[Numeric]
        # Performs autocorrelation of self.data ie:
        ## includingInstance.auto_correlation # returns array of data
        def auto_correlation
            self.cross_correlation(self.data)
        end

        ## 
        # Alias to auto_correlation
        def acorr
            self.cross_correlation(self.data)
        end


    end

    extend self::ClassMethods

end