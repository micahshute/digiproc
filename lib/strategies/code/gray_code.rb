class Dsp::Strategies::GrayCode

    def self.generate(size)
        if size == 1
            ["0", "1"]
        else
            prepend("0", generate(size - 1)) + prepend("1", generate(size - 1).reverse)
        end
    end

    def self.to_binary(bin)
        bits = bin.size
        gray_code = 0
        bit_number = bits - 1
        bit = 0
        while bit_number >= 0
        bit ^= bin >> bit_number & 1
        gray_code |= (1 << bit_number) * bit
        bit_number -= 1
        end
        gray_code.to_s(2)
    end

    def self.to_dec(bin)
        bits = bin.size
        gray_code = 0
        bit_number = bits - 1
        bit = 0
        while bit_number >= 0
        bit ^= bin >> bit_number & 1
        gray_code |= (1 << bit_number) * bit
        bit_number -= 1
        end
        gray_code.to_s
    end

    def self.to_gray(binary)
        (binary ^ (binary >> 1)).to_s(2)
    end

    private

    def self.prepend(prefix, code)
        code.map { |bit| prefix + bit}
    end
end