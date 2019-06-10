# DISREGARD THIS EXAMPLE

#Using Gruff Line

#Below does not work, needs to be re-worked


g = Gruff::Line.new('1000x1000')
distr = Digiproc::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 3, size: 100)
g.data :random, distr.data
gnew = Digiproc::Plottable::ClassMethods::VerticalLine.new(g, 30)
gnew.write('./examples/quickplot/test.png')

