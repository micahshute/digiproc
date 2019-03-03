# ***** Simple functions examples from Dsp::Functions and Dsp::Probability *****


#Gaussian random number generator
pfuncs = Dsp::Probability
nums = []
10.times do 
    nums << pfuncs.nrand
end

puts "Numbers from gaussian distribution:"
puts nums.to_s
puts

# Pearson's Correlation Coefficient from Dsp::Probability
dist1 = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 10, size: 100).data
dist2 = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 10, size: 100).data
corr_coeff = pfuncs.correlation_coefficient(dist1, dist2)
corr_coeff_2 = pfuncs.correlation_coefficient(dist1, Dsp::Functions.process(dist1, ->(x){x * -2 + 3} ))

puts "Correlation coefficient, different random distributions: #{corr_coeff}"
puts "Correlation coefficient, gain and shifted from same distribution #{corr_coeff_2}"
puts

# stddev, mean, variance, covariance, cdf, q, pdf

distribution = Dsp::Probability::RealizedGaussianDistribution.new(mean: 0, stddev: 10, size: 100).data

mean = pfuncs.mean(distribution)
stddev = pfuncs.stddev(distribution)
variance = pfuncs.variance(distribution)
cov = pfuncs.covariance(distribution, distribution)
pdf = pfuncs.pdf(distribution)
cdf = pfuncs.normal_cdf(5, mean, stddev)
q = pfuncs.normal_q(5, mean, stddev)


puts "Mean: #{mean}"
puts "Std. Deviation: #{stddev}"
puts "Variance: #{variance}"
puts "Covaraince: #{cov}"
# puts "PDF: #{pdf}" => Long print - a big hash of value => occurances count 
puts "CDF of 5, at mean: #{mean}, stddev: #{stddev}: #{cdf}"
puts "Q of 5, at mean: #{mean}, stddev: #{stddev}: #{q}"
puts 
puts

# linspace(start, stop, num_points)

t = Dsp::Functions.linspace(0, 5, 10)
puts "Linspace from 0 to 5, 10 numbers"
puts t.to_s
puts

# factorial (includes memoization, you can build memory to allow fact of larger numbers by incrementing fact size) 

fns = Dsp::Functions
puts "Factorial of 23: #{fns.fact(23)}"
puts

# process(vals, eqn) processes values with an equation

eqn = ->(x){ x ** 2 }
vals = [1,2,3,4,5,6]
out = fns.process(vals, eqn)
puts "Output of process: #{out}"
puts 
puts

# maxima, local maxima (relative maxima in order (forward and reverse) -> useful when trying to find local maxima in a fft plot
# where signals of interest are local maxima not absolute maxima)

vals = [1,2,3,4,5,6,5,4,5,4,3,2,5,2,3,4,3,2,3,4,9,6,7,8,7,1]

maxima = fns.maxima(vals)
top_three_maxima = fns.maxima(vals, 3)
local_maximas = fns.local_maxima(vals, 3)

puts "Maxima: #{maxima}"
puts "Top 3 maxima: #{top_three_maxima}"
puts "Local maxima (3): #{local_maximas}"