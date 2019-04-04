##
# Creates a Lowpass filter via the windowing method
class Dsp::LowpassFilter < Dsp::DigitalFilter

    attr_accessor :equation
    
    ##
    # == Inputs
    # size:: [Integer] number of datapoints window should be 
    # window:: [Dsp::WindowStrategy] desired window strategy
    # wo:: [Float] center frequency in radians
    # bw:: [Float] bandwidth in radians
    # correct:: [Boolean] perform frequency corrections to make frequency points more accurate. Defaults to true
    #
    ## Dsp::BandpassFilter.new(size: 1000, wo: Math::PI / 4, bw: Math::PI / 10) 
    def initialize(size:, window: RectangularWindow, wc: , correct: true)
        super(size: size, window: window)
        wc = wc + @window.transition_width * PI if correct
        @equation = ->(n){ 
            n == 0 ? (wc / PI) : (Math.sin(wc * n) / (PI * n)) 
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values.times ideal_filter
        @fft = Dsp::FFT.new(time_data: self.weights)
        @fft.calculate
    end
end