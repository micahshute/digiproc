binomial_dist = Dsp::Probability::TheoreticalBinomialDistribution

six_die_roll = binomial_dist.new(n: 6, p: (1.0/6))

puts "For six die rolls:"

puts "At least one of a specific number: #{1 - (1 - (1.0/6)) ** 6}"
puts "Same as above with binomial dist: #{six_die_roll.probability(1..6)}"
puts "-------------------------------"
puts "Six of a kind: #{1 - ((six_die_roll.probability(0..5)) ** 6)}"
puts "At least 5 of a kind: #{1 - ((six_die_roll.probability(0..4)) ** 6)}"
puts "At least 3 of a predetermined number: #{six_die_roll.probability(3..6)}"
puts "-------------------------------"

puts "Experimental Data"

at_least = 3
die_number = 3
count = 0
r = Random.new
total = 5000000
total.times do 
    rolls = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}
    6.times do
        num = r.rand(6) + 1
        rolls[num] += 1
        if rolls[die_number] == at_least
            count += 1
            break
        end
    end
end

puts "At least #{at_least} #{die_number}s (experimental data): #{count / total.to_f}"

