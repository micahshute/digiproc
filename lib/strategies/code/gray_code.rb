## 
# Strategy for creating the Gray Code of a big stream.
# Capable of encoding or decoding gray code
# Gray code ensures that all adjacent numbers only differ by
# one bit. This will reduce errors caused by a transmission/recieving process
# For information on Gray Code, try looking at https://www.allaboutcir- cuits.com/technical-articles/gray-code-basics/

class Digiproc::Strategies::GrayCode

    ##
    # Input argument = integer indicating how many bits you want 
    # The output will be an array of incrememnting gray code numbers with the 
    # number of specified bits. The output array's length wlll be 2^n where
    # `n` is the input number.
    def self.generate(size)
        if size == 1
            ["0", "1"]
        else
            prepend("0", generate(size - 1)) + prepend("1", generate(size - 1).reverse)
        end
    end

    ##
    # Accepts a n integer.
    # The input integer is the decimal version of a gray code number
    # This method will output a binary number in string form
    # The ouput number is the "regular" number counterpart to the 
    # gray code input number. The output will be in binary form.
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

    ##
    # Accepts a n integer.
    # The input integer is the decimal version of a gray code number
    # This method will output a decimal number in string form
    # The ouput number is the "regular" number counterpart to the 
    # gray code input number. The output will be in decimal form.
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

    ##
    # Accepts a n integer.
    # The input integer is a decimal number that you want to convert to gray code
    # This method will output a binary number in string form
    # The ouput number is the the gray code number counterpart to the input integer.
    def self.to_gray(binary)
        (binary ^ (binary >> 1)).to_s(2)
    end

    private

    def self.prepend(prefix, code)
        code.map { |bit| prefix + bit}
    end
end