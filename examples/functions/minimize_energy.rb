points1 = [[2,1,3],[1,2,4],[-3,-2,-4],[1,-2,4]]
points2 = [[0,1,0],[1,3,3],[-2,-5,-4],[-1,-2,-4]]

# => #translate_center_to_origin can take arguments of individual arrays (of the same length), an array of the points, or an array of a hash with
# the points as the keys and the probability of the points as the value. If no probabilities are given, each point is assumed to be
# equiprobable. The points are then centered around the origin as to reduce the total energy of the points.

min_energy_1 = Dsp::Functions.translate_center_to_origin(points1)
min_energy_2 = Dsp::Functions.translate_center_to_origin(points2)

puts "Translated version of #{points1}: \n\t\n#{min_energy_1}"
puts "\n\n"
puts "Translated version of #{points2}: \n\t\n#{min_energy_2}"
puts "\n\n"
probabilities = [1.0/3, 1.0 / 6, 1.0/6, 1.0/3]
points_probs_1 = {}
points_probs_2 = {}

for i in 0...points1.length do 
    points_probs_1[points1[i]] = probabilities[i]
    points_probs_2[points2[i]] = probabilities[i]
end

min_energy_3 = Dsp::Functions.translate_center_to_origin(points_probs_1)
min_energy_4 = Dsp::Functions.translate_center_to_origin(points_probs_2)

puts "Translated version of #{points_probs_1}: \n\t\n#{min_energy_3}"
puts "\n\n"
puts "Translated version of #{points_probs_2}: \n\t\n#{min_energy_4}"