module Convolvable

    module ClassMethods


        def conv(data1, data2)
            @convolution_strategy.nil? ? BFConvolutionStrategy.conv(data1,data2) : @convolution_strategy.conv(data1,data2)
        end
    end

    module InstanceMethods

            def initialize(strategy = BFConvolutionStrategy)
                @convolution_strategy = strategy
            end

            def conv(incoming_data)
                @convolution_strategy.conv(self.data, incoming_data)
            end
    end

end