#If a word consists of 10 bits with the ability to detect and correct any single bit error 
# but not multiple bit errors, what is the probability of a word being in error? 
# Compare the reduction in probability of a word error by using the error correcting code.

# Given that P(error)=0.00135, as it would be for a +- 1V signal with additive white gaussian noise
# with a variance of 1/9:


bd = Dsp::Probability::TheoreticalBinomialDistribution.new(n: 10, p: 0.00135)
puts "Probability of no errors: #{bd.probability(0)}"
puts "Probability of one error: #{bd.probability(1)}"
puts "Probability of one or more errors(if no code fix): #{bd.probability(1..10)}"
puts "Probability of two or more errors (prob after code fix): #{bd.probability(2..10)}, should equal #{1 - bd.probability(0,1)}"
puts "Reduction in error by using error correcting code: #{bd.probability(1..10) - bd.probability(2..10)}"