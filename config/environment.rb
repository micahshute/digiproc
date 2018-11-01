

#Strategies
require './lib/strategies/fft/radix2_strategy'
require './lib/strategies/convolution/bf_conv'
require './lib/strategies/window/window'
require './lib/strategies/window/blackman_window'
require './lib/strategies/window/hamming_window'
require './lib/strategies/window/hanning_window'
require './lib/strategies/window/rectangular_window'

#Modules
require './lib/concerns/requires_data'
require './lib/concerns/initializable'
require './lib/concerns/convolvable'
require './lib/concerns/fourier_transformable'


#Namespace
require './lib/dsp'


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



