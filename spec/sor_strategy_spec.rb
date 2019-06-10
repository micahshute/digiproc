RSpec.describe Digiproc::Strategies::GaussSeidelStrategy do 

    it "converges and correctly approximates the solution to a linear equation" do 
        a = [[4,1,-1],[2,7,1],[1,-3,12]]
        b = [3,19,31]
        sor = Digiproc::Strategies::SorStrategy.new(a,b)
        x = sor.calculate
        expect((x[0,0] - 1 ).abs).to be < 0.001
        expect((x[1,0] - 2).abs).to be < 0.001
        expect((x[2,0] - 3).abs).to be < 0.001
    end

    it "converges for solutions which make the jacobi strategy diverge" do
        a = [[1,2,1],[2,5,2],[1,3,4]]
        b = [2,1,5]
        sor = Digiproc::Strategies::SorStrategy.new(a,b)
        x = sor.calculate(threshold: 0.0001)
        expect((x[0,0] - 6).abs ).to be < 0.001
        expect((x[1,0] + 3).abs ).to be < 0.001
        expect((x[2,0] - 2).abs ).to be < 0.001
    end

    it "converges for solutions which make the gauss seidel strategy diverge" do
        a = [[1,1,1],[1,-1,-1],[-1,1,-1]]
        b = [6,-4,-2]
        sor = Digiproc::Strategies::SorStrategy.new(a,b)
        x = sor.calculate(w: 0.35, threshold: 0.0001)
        expect((x[0,0] - 1 ).abs).to be < 0.001
        expect((x[1,0] - 2).abs).to be < 0.001
        expect((x[2,0] - 3).abs).to be < 0.001
    end

end