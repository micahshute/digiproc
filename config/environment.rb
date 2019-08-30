
require "bundler/setup"
require 'BigDecimal'
require 'gruff'

require 'matrix'
require 'ostruct'
#Namespace
require 'digiproc'


#Extensions
require_relative '../lib/extensions/core_extensions'

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
require_relative '../lib/strategies/strategies'
require_relative '../lib/strategies/fft/inverse_fft_conjugate_strategy'
require_relative '../lib/strategies/fft/brute_force_dft_strategy'
require_relative '../lib/strategies/fft/radix2_strategy'
require_relative '../lib/strategies/convolution/bf_conv'
require_relative '../lib/strategies/window/window'
require_relative '../lib/strategies/window/blackman_window'
require_relative '../lib/strategies/window/hamming_window'
require_relative '../lib/strategies/window/hanning_window'
require_relative '../lib/strategies/window/rectangular_window'
require_relative '../lib/strategies/companding/custom_companding_strategy'
require_relative '../lib/strategies/gaussian/gaussian_generator'
require_relative '../lib/strategies/orthogonalize/gram_schmidt'
require_relative '../lib/strategies/code/gray_code'
require_relative '../lib/strategies/code/differential_encoding_strategy'
require_relative '../lib/strategies/code/xor_differential_encoding_strategy'
require_relative '../lib/strategies/code/xor_differential_encoding_zero_angle_strategy'
require_relative '../lib/strategies/modulation/phase_shift_keying_strategy'
require_relative '../lib/strategies/linear_algebra/jacobi_strategy'
require_relative '../lib/strategies/linear_algebra/gauss_seidel_strategy'
require_relative '../lib/strategies/linear_algebra/sor_strategy'
require_relative '../lib/strategies/linear_algebra/sor2_strategy'

#Modules
require_relative '../lib/concerns/plottable'
require_relative '../lib/concerns/requires_data'
require_relative '../lib/concerns/initializable'
require_relative '../lib/concerns/convolvable'
require_relative '../lib/concerns/fourier_transformable'
require_relative '../lib/concerns/multipliable'
require_relative '../lib/concerns/data_properties'
require_relative '../lib/functions'
require_relative '../lib/probability/probability'
require_relative '../lib/concerns/os'



#Classes
require_relative '../lib/fft'
require_relative '../lib/signals/digital_signal'
require_relative '../lib/filters/digital_filter.rb'
require_relative '../lib/filters/lowpass_filter.rb'
require_relative '../lib/filters/highpass_filter.rb'
require_relative '../lib/filters/bandpass_filter.rb'
require_relative '../lib/filters/bandstop_filter.rb'
require_relative '../lib/signals/analog_signal'
require_relative '../lib/probability/gaussian_distribution'
require_relative '../lib/probability/theoretical_gaussian_distribution'
require_relative '../lib/probability/bit_generator'
require_relative '../lib/probability/binomial_distribution'
require_relative '../lib/quick_plot'
require_relative '../lib/rbplot'

#Factories
require_relative '../lib/factories/factories'
require_relative '../lib/factories/window_factory'
require_relative '../lib/factories/filter_factory'