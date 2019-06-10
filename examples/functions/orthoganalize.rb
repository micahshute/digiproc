
gs = Digiproc::Strategies::GramSchmidtOrthonormalize
eqn1 = ->(t){Math::E ** (-t)}
eqn2 = ->(t){Math::E ** (-2*t)}
eqn3 = ->(t){Math::E ** (-3*t)}

set1 = Digiproc::AnalogSignal.new(eqn: eqn1, size: 10000, sample_rate:0.1).digitize
set2 = Digiproc::AnalogSignal.new(eqn: eqn2, size: 10000, sample_rate:0.1).digitize
set3 = Digiproc::AnalogSignal.new(eqn: eqn3, size: 10000, sample_rate:0.1).digitize

out1, out2, out3 = gs.new([set1,set2,set3]).output

puts "out1 dot out2 = #{out1.dot out2}"
puts "out1 dot out3 = #{out1.dot out3}"
puts "out2 dot out3 = #{out2.dot out3}"

puts "All three are orthogonal becacuse their dot products are 0"

