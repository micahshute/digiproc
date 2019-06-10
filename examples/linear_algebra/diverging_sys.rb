# Attempt to solve a system of linear equations using these strategies

a = [[2,-3,0],[1,3,-10],[3,0,1]]
b = [-7,9,13]

js = Digiproc::Strategies::JacobiStrategy.new(a,b)
gs = Digiproc::Strategies::GaussSeidelStrategy.new(a,b)
sor = Digiproc::Strategies::Sor2Strategy.new(a,b)

puts js.calculate
puts gs.calculate
puts sor.calculate(w: 0.1)
puts (Matrix.rows(a).inv * Matrix.column_vector(b)).map(&:to_f)