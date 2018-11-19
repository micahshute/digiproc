# require 'pry'
gs = Dsp::Strategies::GramSchmidtOrthonormalize
points = [[2,2,3],[4,1,-12],[-2,6,2],[-22,9,0]]
o = gs.new(points)
puts o.output.to_s
puts o.output[0].dot o.output[1]
puts o.output[1].dot o.output[2]
puts o.output[2].dot o.output[3]
puts o.orthonormalized_matrix[3]
puts o.output[3].dot o.output[0]
# binding.pry