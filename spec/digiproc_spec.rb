RSpec.describe Digiproc do
  it "has a version number" do
    expect(Digiproc::VERSION).not_to be nil
  end

  let(:dataset1) do
    [31, 61, 2, 12, 2, 5, 42, 32, 14, 17, 23, 31]
  end

  let(:dataset2) do
    [21, 17, 16, 27, 1, 12, 32]
  end

  let(:d1d2_conv) do
    [651, 1808,	1575,	2099,	1956,	818,	3049,	3508,	1855,	2654,	2026,	2388,	3096,	2326,	1512,	851, 1108,	992]
  end

  let(:d1d2_xcorr) do 
    [992, 2324,	827,	1306,	2353,	1753,	3450,	3094,	1287,	2244,	2617,	2994,	2504,	1834,	1788,	1244,	1010,	651]
  end

  it "performs convolution correctly" do
    expect(Digiproc::Functions.conv(dataset1, dataset2)).to eq(d1d2_conv)
    expect(Digiproc::Functions.conv(dataset2, dataset1)).to eq(d1d2_conv)
  end

  it "performs convolution the same regardless of arg input order" do
    r = Random.new
    size_1 = r.rand(200)
    size_2 = r.rand(200)
    d1 = []
    d2 = []
    size_1.times do 
      d1 << r.rand(100)
    end

    size_2.times do
      d2 << r.rand(100)
    end

    expect(Digiproc::Functions.conv(d1,d2)).to eq(Digiproc::Functions.conv(d2,d1))
  end

  it "performs cross correlation correctly" do
    expect(Digiproc::Functions.cross_correlation(dataset1, dataset2)).to eq(d1d2_xcorr)
    expect(Digiproc::Functions.cross_correlation(dataset2, dataset1)).to eq(d1d2_xcorr.reverse)
  end

  it "cross correlation is reversed if inputs are put in reversed order" do

    r = Random.new
    size_1 = r.rand(200)
    size_2 = r.rand(200)
    d1 = []
    d2 = []
    size_1.times do 
      d1 << r.rand(100)
    end

    size_2.times do
      d2 << r.rand(100)
    end

    expect(Digiproc::Functions.cross_correlation(d1,d2)).to eq(Digiproc::Functions.cross_correlation(d2,d1).reverse)

  end



end
