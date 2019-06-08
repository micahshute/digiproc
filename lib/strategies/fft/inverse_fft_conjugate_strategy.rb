##
# Strategy for calculating the Inverse Fast Fourier Transform (IFFT)
# O(nlgn) runtime, depends on the FFT strategy to calculate thie IFFT
# Uses "conjugate strategy"
class Dsp::Strategies::IFFTConjugateStrategy

    attr_accessor :data, :strategy

    ##
    # == Input args:
    # data:: Array[Numeric] (DFT values)
    # fft_strategy(Optional):: See Dsp::Strategies::Radix2Strategy for required protocol (This is the default value)
    def initialize(data, fft_strategy = Dsp::Strategies::Radix2Strategy)
        @data = data
        @strategy = fft_strategy.new
    end

    ##
    # No input args
    # Calculate the IFFT given Discrete Fourier Transform (DFT) values
    def calculate
        strategy.data = conjugate(data)
        fft_out = strategy.calculate
        n = fft_out.length.to_f
        conjugate(fft_out){ |real, imag| OpenStruct.new(real: (real / n), imaginary: (imag / n) ) }
    end


    private

    def conjugate(data)
        data.map do |value|
            if value.is_a? Complex
                complex_num = block_given? ? yield(value.real, value.imaginary) : OpenStruct.new(real: value.real, imaginary: value.imaginary)
                Complex(complex_num.real, -1 * complex_num.imaginary)
            else
                real_num = block_given? ? yield(value, 0) : OpenStruct.new(real: value, imaginary: 0)
                real_num.real
            end
        end
    end


end