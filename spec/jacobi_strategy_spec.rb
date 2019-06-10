RSpec.describe Digiproc::Strategies::JacobiStrategy do 

    it "converges and correctly approximates the solution to a linear equation" do 

        a = [[4,1,-1],[2,7,1],[1,-3,12]]
        b = [3,19,31]
        js = Digiproc::Strategies::JacobiStrategy.new(a,b)
        x = js.calculate
        expect((x[0,0] - 1).abs).to be < 0.001
        expect((x[1,0] - 2).abs).to be < 0.001
        expect((x[2,0] - 3).abs).to be < 0.001
    end


    it "diverges for some linear equations" do
        a = [[1,2,1],[2,5,2],[1,3,4]]
        b = [2,1,5]
        js = Digiproc::Strategies::JacobiStrategy.new(a,b)
        x = js.calculate
        expect(x[0,0].to_f.nan? ).to eq true
        expect(x[1,0].to_f.nan? ).to eq true
        expect(x[2,0].to_f.nan?).to eq true
    end

    it "has an option to solve using matrix inverses if divergence occurs" do
        a = [[1,2,1],[2,5,2],[1,3,4]]
        b = [2,1,5]
        js = Digiproc::Strategies::JacobiStrategy.new(a,b)
        x = js.calculate(safety_net: true)
        expect(x[0,0]).to eq 6
        expect(x[1,0]).to eq -3
        expect(x[2,0]).to eq 2

    end

end