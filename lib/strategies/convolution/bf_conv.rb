##
# Strategy for convolving two arrays of numbers
# This is an O(n^2) operation, it is more time efficient
# to use FFT to perform this calculation
class Digiproc::Strategies::BFConvolutionStrategy

    ##
    # == Input Args
    # data1:: Array[Numeric]
    # data2:: Array[Numeric]
    # == Output 
    # convolution:: Numeric
    def self.conv(data1, data2)
        dynamic_data = data1.dup
        static_data = data2.dup
        conv_sum = []
        n = 0
        start, stop = conv_overlap_area(static_data.length, dynamic_data.length, n)
        while start <= stop
            sum = 0
            for val in start..stop
                sum += static_data[val] * dynamic_data[transform_to_local_index(val, n)]
            end
            conv_sum << sum
            n = conv_sum.length
            start, stop = conv_overlap_area(static_data.length, dynamic_data.length, n)
        end
        conv_sum
      end

      private
    
      ##
      # Gives start and stop values of overlap inclusive
      def self.conv_overlap_area(static_len, dynamic_len, n)
          dynamic_lo = transform_to_global_index(dynamic_len - 1, n)
          dynamic_hi = transform_to_global_index(0, n)
          static_lo = 0
          static_hi = static_len - 1
          start = dynamic_lo > static_lo ? dynamic_lo : static_lo
          stop = dynamic_hi < static_hi ? dynamic_hi : static_hi
          return [start, stop]
      end
    
      def self.transform_index(index, xform)
          xform.call(index)
      end
    
      def self.transform_to_global_index(index, n)
          transform_index(index, ->(i){ n - i })
      end
    
      def self.transform_to_local_index(index, n)
          transform_index(index, ->(i){ n - i})
      end

end 