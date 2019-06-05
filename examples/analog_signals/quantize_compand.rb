# For the signals:
# x1(t)=8cos(20πt)
# x2(t)=cos(20πt)

# Find Normalized Quantization RMS Error:

# AnalogSignal class accepts an equation, sample rate, and size. Quantization bits, quantization max and min values, and a companding equation are optional.
# Once the #digitize method is called on the initialized class:
# The digital signal is sampled at the given sample rate for the given size number of samples
# If a companding strategy is given, the compression of bits is applied to the samples
# If a number of quantization bits are inputted, the values are quantized based on the number of bits desired as well as the max and min quantization values passed in.
# To perform the quantization, you can follow the progression which starts in the #quantize method. First, the samples are mapped from the passed in max and min values to −1⟺+1 Then, the value is multiplied by the number of bits squared divided by 2. That value is rounded to the nearest integer, and then mapped back down to the original max and min values.
# After quantization, if a companding strategy was given, the quantized samples are run through the expansion algorithm.
# This leaves you with the final answer, which is returned from the #digitize method
# The normalized RMS Error average value is calculated in the #normalized_quantization_rms_error method and is done so via the original sample values and the quantized output of the #digitize method.


x1 = Dsp::AnalogSignal.new(eqn: ->(t){ 8 * Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6,quantization_bits: 4, quant_max: 8, quant_min: -8)
x2 = Dsp::AnalogSignal.new(eqn: ->(t){  Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6,quantization_bits: 4, quant_max: 8, quant_min: -8)
puts "x(1): "
x1.digitize
puts "Normalized Quantization RMS Error: #{x1.normalized_quantization_rms_error.round(3)}"
puts "\n\nx(2):"
x2.digitize
puts "Normalized Quantization RMS Error: #{x2.normalized_quantization_rms_error.round(3)}"
puts
puts "x1 raw samples: #{x1.raw_samples.map{|s| s.round(2)}}"
puts "x1 quantized samples: #{x1.quantized_samples}"

puts 

puts "x2 raw samples: #{x2.raw_samples.map{|s| s.round(2)}}"
puts "x2 quantized samples: #{x2.quantized_samples}"


# Now use a compander to attempt to reduce Quantization error:


compression_eqn = ->(n){ n < 0 ? (-4 * ((-n) ** (1.0 / 3))) : (4 * n ** (1.0 / 3))}
expansion_eqn =->(n){ n < 0 ? ((-1.0 / 64) * ((-n) ** 3)) : ((1.0 / 64) * n ** 3)}
compander = Dsp::Strategies::CustomCompandingStrategy.new(compression_eqn, expansion_eqn)
 

x1 = Dsp::AnalogSignal.new(eqn: ->(t){ 8 * Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6,quantization_bits: 4, quant_max: 8, quant_min: -8, companding_strategy: compander)
x2 = Dsp::AnalogSignal.new(eqn: ->(t){  Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6,quantization_bits: 4, quant_max: 8, quant_min: -8, companding_strategy: compander)
 

puts "\n\nx(1) with companding: "

x1.digitize

puts "Normalized Quantization RMS Error: #{x1.normalized_quantization_rms_error.round(3)}"


puts "\n\nx(2) with companding:"

x2.digitize

puts "Normalized Quantization RMS Error: #{x2.normalized_quantization_rms_error.round(3)}"

puts "x3 raw samples: #{x1.raw_samples.map{|s| s.round(2)}}"
puts "x1 quantized samples: #{x1.quantized_samples}"

puts 

puts "x2 raw samples: #{x2.raw_samples.map{|s| s.round(2)}}"
puts "x2 quantized samples: #{x2.quantized_samples}"

puts "Companding then reduced Quantization error for the low-amplitude signal x2, but raised it for the higher-amplitude signal x1"