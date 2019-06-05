# Iteratively solve a system of linear equations using these strategies

a = [[10,4,0,0],[0,7,0,3],[9,0,8,1],[1,0,0,1]]
b = [52,24,61,5]

js = Dsp::Strategies::JacobiStrategy.new(a,b)
gs = Dsp::Strategies::GaussSeidelStrategy.new(a,b)
sor = Dsp::Strategies::SorStrategy.new(a,b)

puts js.calculate
puts gs.calculate
puts sor.calculate(w: 0.5)
puts (Matrix.rows(a).inv * Matrix.column_vector(b)).map(&:to_f)

a = [
        [1,-1,-1,-1,-1,-1],
        [-1,2,0,0,0,0],
        [-1,0,3,1,1,1],
        [-1,0,1,4,2,2],
        [-1,0,1,2,5,3],
        [-1,0,1,2,3,6]
    ]

    b = [-4,1,5,8,10,11]

    sor = Dsp::Strategies::SorStrategy.new(a,b)
    puts sor.calculate(w: 0.5, threshold: 0.000001)