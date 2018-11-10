# x1 = Dsp::AnalogSignal.new(eqn: ->(t){ 8 * Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6, quantization_bits: 4, quant_max: 8, quant_min: -8)
# x2 = Dsp::AnalogSignal.new(eqn: ->(t){  Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6, quantization_bits: 4, quant_max: 8, quant_min: -8)

# compression_eqn = ->(n){ n < 0 ? (-4 * ((-n) ** (1.0 / 3))) : (4 * n ** (1.0 / 3))}
# expansion_eqn =->(n){ n < 0 ? ((-1.0 / 64) * ((-n) ** 3)) : ((1.0 / 64) * n ** 3)}
# compander = CustomCompandingStrategy.new(compression_eqn, expansion_eqn)

# x3 = Dsp::AnalogSignal.new(eqn: ->(t){ 8 * Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6, quantization_bits: 4, quant_max: 8, quant_min: -8, companding_strategy: compander)
# x4 = Dsp::AnalogSignal.new(eqn: ->(t){  Math.cos(20 * Math::PI * t) }, sample_rate: 1.0 / 51.0, size: 6, quantization_bits: 4, quant_max: 8, quant_min: -8, companding_strategy: compander)

# puts "x(1): "
# puts x1.digitize.to_s
# puts "Raw samples: #{x1.raw_samples}"
# puts "Normalized Quantization RMS Error: #{x1.normalized_quantization_rms_error.round(3)}"
# puts "\n\nx(2):"
# puts x2.digitize.to_s
# puts "Raw samples: #{x2.raw_samples}"
# puts "Normalized Quantization RMS Error: #{x2.normalized_quantization_rms_error.round(3)}"
# puts "\n\nx(1) with companding: "
# puts x3.digitize.to_s
# puts "Raw samples: #{x3.raw_samples}"
# puts "Normalized Quantization RMS Error: #{x3.normalized_quantization_rms_error.round(3)}"
# puts "\n\nx(2) with companding:"
# puts x4.digitize.to_s
# puts "Raw samples: #{x4.raw_samples}"
# puts "Normalized Quantization RMS Error: #{x4.normalized_quantization_rms_error.round(3)}"
# binding.pry

# signal = ->(t){Math.cos(2 * Math::PI * t)} #cos at 1 Hz
# sample_times = (0..1000).map{ |int| int / 100.0} #Sample for 10 seconds every 0.01 seconds (100 times per period over 10 periods)
# data = sample_times.map{ |time| signal.call(time) }
# ft = []
# for k in 0...data.length do
#     tot = 0
#     data.each_with_index do |x_n, n|
#         tot += x_n * Math::E ** (Complex(0,-1) * 2.0 * Math::PI * k * n / data.length.to_f)
#     end
#     ft << tot
# end

# fft = Dsp::FFT.new(data: data).calculate


test = [1,2,3,4]
ft = Dsp::FFT.new(time_data: test)
ft.calculate
iff = Dsp::Strategies::IFFTConjugateStrategy.new(ft.fft)
iff.calculate


binding.pry