RSpec.describe Dsp::DataProperties do

    let(:positive_slope) do
        Dsp::DataProperties.find_slope(83, 83.5)
    end

    let(:negative_slope) do
        Dsp::DataProperties.find_slope(73,72.9)
    end

    let(:zero_slope) do
        Dsp::DataProperties.find_slope(3.0, 3.0)
    end

    let(:max_test_one) do
        {
            test: [ 8,2,9,1,4,3,7,6,7,5,6,3,4,1],
            solution: [ {0 => 8}, {2 => 9}, {4 => 4}, {6 => 7} ,{8 => 7}, {10 => 6}, {12 => 4}]

        }
    end

    let (:max_test_two) do
        {
            test: [1,2,3,4,3,2,2,2,3,4,5,5,5,5,4,3,4,8,7,8,8,8,7,8,7,6,5,6,5,4],
            solution: [
                {3 => 4}, {10 => 5}, {17 => 8}, {19 => 8}, {23 => 8}, {27 => 6}
            ]

        }
    end

    it "#find_slope returns the proper slope object" do
        expect(Dsp::DataProperties.find_slope(4,6).is :positive).to eq(true)
        expect(Dsp::DataProperties.find_slope(19,2).is :negative).to eq(true)
        expect(Dsp::DataProperties.find_slope(20.0, 20.0).is :zero).to eq(true)
        expect(positive_slope).to eq(Dsp::DataProperties::Slope.Positive)
        expect(negative_slope).to eq(Dsp::DataProperties::Slope::Negative)
        expect(zero_slope).to eq(Dsp::DataProperties::Slope::Zero)
        expect(negative_slope == :negative).to eq(true)
        expect(positive_slope == "positive").to eq(true)
        expect(zero_slope == :zero).to eq(true)
    end

    it "#all_maxima returns a list of all maxima in a data set" do
        expect(Dsp::DataProperties.all_maxima(max_test_one[:test]).map{|os| {os.index => os.value}}).to eq(max_test_one[:solution])
        expect(Dsp::DataProperties.all_maxima(max_test_two[:test]).map{|os| { os.index => os.value}}).to eq(max_test_two[:solution])

    end


    it "#maxima returns the largest x magnitude maxima in the dataset" do
        expect(true).to eq(false)
    end

    it "#local_maxima returns the largest x magnitude maxima which ard the largest compared to their surrounding maxima" do
        expect(true).to eq(false)
    end

end
