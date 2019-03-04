## 
# This module contains class methods and instance methods for classes which have properties of `data` which 
# are arrays and can undergo convolution, correlation, cross-correlation, and autocorrelation. As such, if 
# a class `includes` Convolvable::InstanceMethods, it is also including `Dsp::RequiresData` which ensures that the
# class has a `data` property

module Dsp::Convolvable

    module ClassMethods

        def convolve(data1, data2, strategy = Dsp::Strategies::BFConvolutionStrategy)
            # convolve(data1: Array, data2: Array, strategy: ConvolutionStrategy)
            # strategy can be custom-written as long as it matches the ConvolutionStrategy interface: 
            # have a class method called `conv` which takes 2 arrays and convolves them
            conv(data1, data2, strategy)
        end

        def conv(data1, data2, strategy = Dsp::Strategies::BFConvolutionStrategy)
            # Same as #convolve
            strategy.conv(data1,data2)
        end

        def cross_correlation(data1, data2)
            # Uses the #conv method to perform cross_correlation by reversing the second data set order
            # Does not accept a strategy as a third parameter
            conv(data1, data2.reverse)
        end

        def xcorr(data1, data2)
            # Alias to #cross_correlation
            cross_correlation(data1, data2)
        end

        def auto_correlation(data)
            # auto_correlation(data: Array)
            # Uses the cross_correlation method
            cross_correlation(data, data)
        end

        def acorr(data)
            # Alias to #auto_correlation
            cross_correlation(data, data)
        end

    end

    module InstanceMethods

        def self.included(base)
            base.class_eval do 
                include Dsp::RequiresData
            end
        end

        def initialize(strategy: Dsp::Strategies::BFConvolutionStrategy)
            # Optionally initializable with a `ConvolutionStrategy` (see `Dsp::Initializable`)
            @convolution_strategy = strategy
        end

        def convolve(incoming_data)
            # convolve(incoming_data: Array [or a class including Dsp::RequiresData]) uses the `strategy` class to convolve the included class' data
            # property with the array provided as an argument
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data)
        end

        def conv(incoming_data)
            # Alias to convolve
            self.convolve(incoming_data)
        end

        def convolution_strategy
            # If class is not `Initializable`, use Dsp::BFConvolutionStrategy
            @convolution_strategy.nil? ? Dsp::Strategies::BFConvolutionStrategy : @convolution_strategy
        end

        def cross_correlation(incoming_data)
            # cross_correlation(incoming_data: Array [or a class extending Dap::RequiresData])
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data.reverse)
        end

        def xcorr(incoming_data)
            #Alias to cross_correlation
            self.cross_correlation(incoming_data)
        end

        def auto_correlation
            # autocorrelations self.data
            self.cross_correlation(self.data)
        end

        def acorr
            # alias to auto_correlation
            self.cross_correlation(self.data)
        end


    end

end