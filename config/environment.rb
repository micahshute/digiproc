require 'ostruct'
#Namespace
require './lib/dsp'


#Strategies
require './lib/strategies/strategies'
require './lib/strategies/fft/inverse_fft_conjugate_strategy'
require './lib/strategies/fft/brute_force_dft_strategy'
require './lib/strategies/fft/radix2_strategy'
require './lib/strategies/convolution/bf_conv'
require './lib/strategies/window/window'
require './lib/strategies/window/blackman_window'
require './lib/strategies/window/hamming_window'
require './lib/strategies/window/hanning_window'
require './lib/strategies/window/rectangular_window'
require './lib/strategies/companding/custom_companding_strategy'
require './lib/strategies/gaussian/gaussian_generator'

#Modules
require './lib/concerns/requires_data'
require './lib/concerns/initializable'
require './lib/concerns/convolvable'
require './lib/concerns/fourier_transformable'
require './lib/concerns/multipliable'
require './lib/concerns/data_properties'
require './lib/functions'
require './lib/probability/probability'


#Extensions
require './lib/extensions/core_extensions'

Array.include Dsp::CoreExtensions::ArrayExtension::DotProduct
Array.include Dsp::CoreExtensions::ArrayExtension::Sum 
Math.extend Dsp::CoreExtensions::MathExtension::Decible

require './lib/extensions/array_extension'

#Classes
require './lib/fft'
require './lib/signals/digital_signal'
require './lib/filters/digital_filter.rb'
require './lib/filters/lowpass_filter.rb'
require './lib/filters/highpass_filter.rb'
require './lib/filters/bandpass_filter.rb'
require './lib/filters/bandstop_filter.rb'
require './lib/signals/analog_signal'
require './lib/probability/gaussian_distribution'
require './lib/probability/theoretical_gaussian_distribution'


