
require "bundler/setup"

require 'gruff'

require 'matrix'
require 'ostruct'
#Namespace
require 'digiproc'


#Extensions
require './lib/extensions/core_extensions'

Array.include Digiproc::CoreExtensions::ArrayExtension::DotProduct
Array.include Digiproc::CoreExtensions::ArrayExtension::Sum 
Array.include Digiproc::CoreExtensions::ArrayExtension::Multiply
Math.extend Digiproc::CoreExtensions::MathExtension::Decible
Vector.include Digiproc::CoreExtensions::VectorExtension::Projection::InstanceMethods
Vector.extend Digiproc::CoreExtensions::VectorExtension::Projection::ClassMethods
# Float.include Digiproc::CoreExtensions::FloatExtension::OddPatch
class Gruff::Base

    def draw_label(x_offset, index)
        return if @hide_line_markers
        if !@labels[index].nil? && @labels_seen[index].nil?
          y_offset = @graph_bottom + LABEL_MARGIN
          y_offset += @label_stagger_height if ((index.respond_to? :odd?) && index.odd?)
          label_text = labels[index].to_s
          if label_text.size > @label_max_size
            if @label_truncation_style == :trailing_dots
              if @label_max_size > 3
                # 4 because '...' takes up 3 chars
                label_text = "#{label_text[0 .. (@label_max_size - 4)]}..."
              end
            else # @label_truncation_style is :absolute (default)
              label_text = label_text[0 .. (@label_max_size - 1)]
            end
  
          end
  
          if x_offset >= @graph_left && x_offset <= @graph_right
            @d.fill = @font_color
            @d.font = @font if @font
            @d.stroke('transparent')
            @d.font_weight = NormalWeight
            @d.pointsize = scale_fontsize(@marker_font_size)
            @d.gravity = NorthGravity
            @d = @d.annotate_scaled(@base_image,
                                    1.0, 1.0,
                                    x_offset, y_offset,
                                    label_text, @scale)
          end
          @labels_seen[index] = 1
          debug { @d.line 0.0, y_offset, @raw_columns, y_offset }
        end
    end

end

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
require './lib/strategies/code/gray_code'
require './lib/strategies/code/differential_encoding_strategy'
require './lib/strategies/code/xor_differential_encoding_strategy'
require './lib/strategies/code/xor_differential_encoding_zero_angle_strategy'
require './lib/strategies/modulation/phase_shift_keying_strategy'
require './lib/strategies/linear_algebra/jacobi_strategy'
require './lib/strategies/linear_algebra/gauss_seidel_strategy'
require './lib/strategies/linear_algebra/sor_strategy'
require './lib/strategies/linear_algebra/sor2_strategy'

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
require './lib/concerns/os'



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
require './lib/probability/bit_generator'
require './lib/probability/binomial_distribution'
require './lib/quick_plot'
require './lib/rbplot'

#Factories
require './lib/factories/factories'
require './lib/factories/window_factory'
require './lib/factories/filter_factory'