require 'matrix'
require 'ostruct'
#Namespace
require './lib/dsp'


#Extensions
require './lib/extensions/core_extensions'

Array.include Dsp::CoreExtensions::ArrayExtension::DotProduct
Array.include Dsp::CoreExtensions::ArrayExtension::Sum 
Array.include Dsp::CoreExtensions::ArrayExtension::Multiply
Math.extend Dsp::CoreExtensions::MathExtension::Decible
Vector.include Dsp::CoreExtensions::VectorExtension::Projection::InstanceMethods
Vector.extend Dsp::CoreExtensions::VectorExtension::Projection::ClassMethods

require './lib/extensions/array_extension'

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
require './lib/strategies/orthogonalize/gram_schmidt'

#Modules
require './lib/concerns/plottable'
require './lib/concerns/requires_data'
require './lib/concerns/initializable'
require './lib/concerns/convolvable'
require './lib/concerns/fourier_transformable'
require './lib/concerns/multipliable'
require './lib/concerns/data_properties'
require './lib/functions'
require './lib/probability/probability'




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
require './lib/quick_plot'

#Factories
require './lib/factories/factories'
require './lib/factories/window_factory'
require './lib/factories/filter_factory'