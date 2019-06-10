RSpec.describe Digiproc::DataProperties do

    let(:positive_slope) do
        Digiproc::DataProperties.find_slope(83, 83.5)
    end

    let(:negative_slope) do
        Digiproc::DataProperties.find_slope(73,72.9)
    end

    let(:zero_slope) do
        Digiproc::DataProperties.find_slope(3.0, 3.0)
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
                {3 => 4}, {13 => 5}, {17 => 8}, {21 => 8}, {23 => 8}, {27 => 6}
            ]

        }
    end

    let (:max_test_three) do 

        {
            test: [20, 20, 20, 9, 8, 7,10,7,6,8,6,5,6,5,4,5,4,3,7,4,3,2,3,2,1,2,1,2,1,6,2,1],
            solution_all: [
                {2 => 20}, {6 => 10}, {9 => 8}, {12 => 6}, {15 => 5}, {18 => 7}, {22 => 3}, {25 => 2}, {27 => 2}, {29 => 6}
            ],
            solution_top_5: [
                {2 => 20}, {6 => 10}, {9 => 8}, {18 => 7}, {12 => 6}
            ],
            solution_local_top_3: [
                {29 => 6}, {2 => 20}, {18 => 7}
            ]
        }
    end

    it "#find_slope returns the proper slope object" do
        expect(Digiproc::DataProperties.find_slope(4,6).is? :positive).to eq(true)
        expect(Digiproc::DataProperties.find_slope(19,2).is? :negative).to eq(true)
        expect(Digiproc::DataProperties.find_slope(20.0, 20.0).is? :zero).to eq(true)
        expect(positive_slope).to eq(Digiproc::DataProperties::Slope.Positive)
        expect(negative_slope).to eq(Digiproc::DataProperties::Slope::Negative)
        expect(zero_slope).to eq(Digiproc::DataProperties::Slope::Zero)
        expect(negative_slope == :negative).to eq(true)
        expect(positive_slope == "positive").to eq(true)
        expect(zero_slope == :zero).to eq(true)
    end

    it "#all_maxima returns a list of all maxima in a data set" do
        expect(Digiproc::DataProperties.all_maxima(max_test_one[:test]).map{ |os| {os.index => os.value}}).to eq(max_test_one[:solution])
        expect(Digiproc::DataProperties.all_maxima(max_test_two[:test]).map{ |os| { os.index => os.value}}).to eq(max_test_two[:solution])
        expect(Digiproc::DataProperties.all_maxima(max_test_three[:test]).map{ |os| { os.index => os.value}}).to eq(max_test_three[:solution_all])
    end


    it "#maxima returns the largest x magnitude maxima in the dataset" do
        expect(Digiproc::DataProperties.maxima(max_test_one[:test], 3).map{ |os| {os.index => os.value}}).to eq([{2 => 9},{0 => 8},{6 => 7}])
        expect(Digiproc::DataProperties.maxima(max_test_two[:test], 3).map{ |os| { os.index => os.value}}).to eq(max_test_two[:solution][2,3])
        expect(Digiproc::DataProperties.maxima(max_test_three[:test], 5).map{ |os| { os.index => os.value}}).to eq(max_test_three[:solution_top_5])
    end

    it "#local_maxima returns the largest x magnitude maxima which ard the largest compared to their surrounding maxima" do
        expect(Digiproc::DataProperties.local_maxima(max_test_three[:test], 3).map{ |os| { os.index => os.value}}).to eq(max_test_three[:solution_local_top_3])
        expect(Digiproc::DataProperties.local_maxima([5], 3).map{ |os| { os.index => os.value}}).to eq([0 => 5])
        expect(Digiproc::DataProperties.local_maxima([5, 2], 3).map{ |os| { os.index => os.value}}).to eq([0 => 5])
        expect(Digiproc::DataProperties.local_maxima([2, 5, 2, 10], 3).map{ |os| { os.index => os.value}}).to eq([{3 => 10},{1 => 5}])
    end

end
