require 'pry'
gs = Dsp::Strategies::GramSchmidtOrthonormalize
eqn1 = ->(t){Math::E ** (-t)}
eqn2 = ->(t){Math::E ** (-2*t)}
eqn3 = ->(t){Math::E ** (-3*t)}

set1 = Dsp::AnalogSignal.new(eqn: eqn1, size: 10000, sample_rate:0.1).digitize
set2 = Dsp::AnalogSignal.new(eqn: eqn2, size: 10000, sample_rate:0.1).digitize
set3 = Dsp::AnalogSignal.new(eqn: eqn3, size: 10000, sample_rate:0.1).digitize

out1, out2, out3 = gs.new([set1,set2,set3]).output

expected_eqn_1 = ->(t){Math.sqrt(2) * Math::E ** (-t)}
expected_eqn_2 = ->(t){6 * Math::E ** (-2 * t) - 4 * Math::E ** (-t) }
expected_eqn_3 = ->(t){(Math.sqrt(600)) * Math::E ** (-3 * t) - (Math.sqrt(600) * 6.0 / 5) * Math::E ** (-2*t) + (Math.sqrt(600) * 3.0 / 10)* Math::E ** (-t) }

expected_set_1 = Vector.elements(Dsp::AnalogSignal.new(eqn: expected_eqn_1, size: 10000, sample_rate: 0.1).digitize).normalize
expected_set_2 = Vector.elements(Dsp::AnalogSignal.new(eqn: expected_eqn_2, size: 10000, sample_rate: 0.1).digitize).normalize
expected_set_3 = Vector.elements(Dsp::AnalogSignal.new(eqn: expected_eqn_3, size: 10000, sample_rate: 0.1).digitize).normalize

# binding.pry
match = true
count = 0
out1.each.with_index do |out, i|
    if out.round(10) != expected_set_1[i].round(10)
        count += 1
        match = false 
        puts "#{out.round(10)} does not match #{expected_set_1[i].round(10)}"
    end
end
if match 
    puts "All elements from phi1 matched expected outcome" 
else
    puts "#{count} elements did not match in phi1"
end
match = true
count = 0
out2.take(5).each.with_index do |out, i|
    if out.round(5) != expected_set_2[i].round(5)
        count += 1
        match = false 
        puts "#{out.round(5)} does not match #{expected_set_2[i].round(5)} -> elment #{i} of phi2"
    end
end
if match 
    puts "All elements from phi1 matched expected outcome" 
else
    puts "#{count} / 5 elements did not match in phi2"
end
match = true
count = 0
out3.take(5).each.with_index do |out, i|
    if out.round(3) != expected_set_3[i].round(3)
        count += 1
        match = false 
        puts "#{out.round(5)} does not match #{expected_set_3[i].round(5)} -> element #{i} of phi3"
    end
end
if match 
    puts "All elements from phi1 matched expected outcome" 
else
    puts "#{count} / 5 elements did not match in phi3"
end

puts "out1 dot out2 = #{out1.dot out2}"
puts "out1 dot out3 = #{out1.dot out3}"
puts "out2 dot out3 = #{out2.dot out3}"


puts "expected1 dot expected2 = #{expected_set_1.dot expected_set_2}"
puts "expected1 dot expected3 = #{expected_set_1.dot expected_set_3}"
puts "expected2 dot expected3 = #{expected_set_2.dot expected_set_3}"


# binding.pry

