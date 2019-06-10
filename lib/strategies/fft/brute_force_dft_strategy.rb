##
# A brute force Discrete Fourier Transform strategy
# O(n^2) algorith, no reason to sue it over FFT unless you 
# don't want to work within the parameters of a Radix2 strategy 
# (ie data points of DFT size will be a power of 2). This strategy does
# not have those parameters
class Digiproc::BFDFTStrategy

    attr_accessor :data

    # initialize with an array of numerics
    def initialize(data)
        @data = data.dup
    end

    # Calculate the DFT with an O(n^2) algorithm
    # Can accept an array of numerics, with a default value of 
    # @data
    def calculate(data = @data)
        ft = []
        for k in 0...data.length do
            tot = 0
            data.each_with_index do |x_n, n|
                tot += x_n * Math::E ** (Complex(0,-1) * 2.0 * Math::PI * k * n / data.length.to_f)
            end
            ft << tot
        end
        ft
    end

end