class Dsp::BFDFTStrategy

    attr_accessor :data

    def initialize(data)
        @data = data.dup
    end


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