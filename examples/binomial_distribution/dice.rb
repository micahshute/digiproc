binomial_dist = Dsp::Probability::TheoreticalBinomialDistribution

three_of_a_kind = binomial_dist.new(n: 6, p: (1.0/6))
puts three_of_a_kind.probability(6) * 6