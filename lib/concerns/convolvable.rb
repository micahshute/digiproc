module Convolvable

    module ClassMethods

        def convolve(data1, data2, strategy = BFConvolutionStrategy)
            conv(data1, data2, strategy)
        end

        def conv(data1, data2, strategy = BFConvolutionStrategy)
            strategy.conv(data1,data2)
        end

        def cross_correlation(data1, data2)
            conv(data1, data2.reverse)
        end

        def xcorr(data1, data2)
            cross_correlation(data1, data2)
        end

        def auto_correlation(data)
            cross_correlation(data, data)
        end

        def acorr(data)
            cross_correlation(data, data)
        end

    end

    module InstanceMethods

        def self.included(base)
            base.class_eval do 
                include RequiresData
            end
        end

        def initialize(strategy: BFConvolutionStrategy)
            @convolution_strategy = strategy
        end

        def convolve(incoming_data)
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data)
        end

        def conv(incoming_data)
            self.convolve(incoming_data)
        end

        def convolution_strategy
            @convolution_strategy.nil? ? BFConvolutionStrategy : @convolution_strategy
        end

        def cross_correlation(incoming_data)
            incoming_data = incoming_data.is_a?(Array) ? incoming_data : incoming_data.data
            self.convolution_strategy.conv(self.data, incoming_data.reverse)
        end

        def xcorr(incoming_data)
            self.cross_correlation(incoming_data)
        end

        def auto_correlation
            self.cross_correlation(self.data)
        end

        def acorr
            self.cross_correlation(self.data)
        end


    end

end