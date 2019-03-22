RSpec.describe Dsp::Strategies::JacobiStrategy do 

    it "converges and correctly approximates the solution to a linear equation" do 

        a = [[4,1,-1],[2,7,1],[1,-3,12]]
        b = [3,19,31]
        gs = Dsp::Strategies::JacobiStrategy.new(a,b)
        x = gs.calculate
        expect(x[0,0] - 1 ).to be < 0.001
        expect(x[1,0] - 2).to be < 0.001
        expect(x[2,0] - 3).to be < 0.001
    end


end