module Convolvable

    module ClassMethods


        def conv(data1, data2, strategy = BFConvolutionStrategy)
            strategy.conv(data1,data2)
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