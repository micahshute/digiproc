## Gray code maps "normal" numbers to a binary code in which adjacent numbers
## only change by one bit. This reduced errors in the whole number when you 
## there is an error decoding a single bit

gc_gen = Dsp::Strategies::GrayCode


three_bit_gray_code = gc_gen.generate(3)

puts three_bit_gray_code.to_s
puts "In decimal:"
gray_dec = three_bit_gray_code.map{ |gc| gc.to_i(2) }
puts gray_dec.to_s


puts "decode:"
puts "map gray code back to its original number"

orig_dec = gray_dec.map{ |dec| gc_gen.to_dec(dec) }
puts orig_dec.to_s

puts orig_bin = gray_dec.map{ |dec| gc_gen.to_binary(dec)}.to_s
