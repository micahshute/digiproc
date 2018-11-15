g = Gruff::Line.new('1000x1000')
distr = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 3, size: 100)
g.data :random, distr.data
gnew = Dsp::Plottable::ClassMethods::VerticalLine.new(g, 30)
gnew.write('./examples/quickplot/test.png')