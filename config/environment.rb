
#Strategies
require './lib/strategies/fft/radix2_strategy'
require './lib/strategies/convolution/bf_conv'

#Modules
require './lib/concerns/initializable'
require './lib/concerns/convolvable'

#Namespace
require './lib/dsp'


#Extensions
require './lib/extensions/core_extensions'

Array.include Dsp::CoreExtensions::Array::DotProduct
Array.include Dsp::CoreExtensions::Array::Sum 

require './lib/extensions/array_extension'

#Classes
require './lib/fft'
require './lib/signals/digital_signal'
require './lib/filters/digital_filter.rb'
require './lib/filters/lowpass_filter.rb'
require './lib/filters/highpass_filter.rb'
require './lib/filters/bandpass_filter.rb'
require './lib/filters/bandstop_filter.rb'



