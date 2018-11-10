class Dsp::Strategies::IFFTConjugateStrategy

    attr_accessor :data, :strategy

    def initialize(data, fft_strategy = Radix2Strategy)
        @data = data
        @strategy = fft_strategy.new
    end

    def calculate
        strategy.data = conjugate(data)
        fft_out = strategy.calculate
        n = fft_out.length.to_f
        puts fft_out.to_s
        conjugate(fft_out){ |real, imag| OpenStruct.new(real: real / n, imaginary: imag / n) }
    end

    def calculate1
        split_data = split
        strategy.data = split_data.real
        real_out = strategy.calculate
        strategy.data = split_data.imag.map{|val| -val }
        imag_out = strategy.calculate
        n = real_out.length.to_f
        ifft = []
        for i in 0...real_out.length
            ifft << Complex(real_out[i] / n, -1 * imag_out[i] / n)
        end
        ifft
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

    def split
        split_data = OpenStruct.new
        split_data.real = []
        split_data.imag = []
        data.each do |value|
            if data.is_a? Complex
                split_data.real << value.real
                split_data.imag << value.imaginary
            else
                split_data.real << value
                split_data.imag << 0
            end
        end
        split_data
    end


end