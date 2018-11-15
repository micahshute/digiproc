RSpec.describe Array do

    it "allows array multiplication" do
        expect([1,2,3].times [1,2,3]).to eq([1,4,9])
    end

    it "only allows multiplicaiton of arrays of the same size" do
        expect{[1,2,3].times [4,5,6,7]}.to raise_error(ArgumentError)
    end

    it "allows array addition" do 
        expect([1,2,3].plus([1,2,3])).to eq([2,4,6])
    end

    it "only allows addition of arrays of the same size" do
        expect{[1,2,3].plus([1,2,3,4])}.to raise_error(ArgumentError)
    end

    it "allows dot product calculation" do
        expect([1,2,3].dot [2,4,6]).to eq(28)
    end
end