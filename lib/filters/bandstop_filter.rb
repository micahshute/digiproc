
## 
# Creates a bandstop filter via the Windowing Method

class Digiproc::BandstopFilter < Digiproc::DigitalFilter
    attr_accessor :equation

    ##
    # == Inputs
    # size:: [Integer] number of datapoints window should be 
    # window:: [Digiproc::WindowStrategy] desired window strategy
    # wo:: [Float] center frequency in radians
    # bw:: [Float] bandwidth in radians
    # wlp_upper:: [Float] Upper frequency limit (radians) of the lowpass passband
    # whp_lower:: [Float] Lower frequency limit (radians) of the highpass passband
    # correct:: [Boolean] perform frequency corrections to make frequency points more accurate. Defaults to true
    #
    # Must have either `wo` and `bw` or `wlp_upper` and `whp_lower`
    # For wo and bw, include the "don't care" areas in the bandstop area
    #
    ## Digiproc::BandpassFilter.new(size: 1000, wo: Math::PI / 4, bw: Math::PI / 10) 
    def initialize(size:, window: RectangularWindow, wo: nil, bw: nil, wlp_upper: nil , whp_lower: nil, correct: true )

        super(size: size, window: window)
        
        if !!wo && !!bw
            bw += (@window.transition_width * 2 * PI)
            wlp_upper = wo - bw / 2.0
            whp_lower = wo + bw / 2.0
        else
            raise ArgumentError.new("You must provide either bandwidth and center freq or frequency bands") if wlp_upper.nil? or whp_lower.nil? 
            wlp_upper += @window.transition_width * PI if correct
            whp_lower -= @window.transition_width * PI if correct
        end
        
        @equation = ->(n){ 
            n == 0 ?  (wlp_upper / PI) + (( PI - whp_lower )/ PI ) : ((Math.sin(wlp_upper * n) - Math.sin(whp_lower * n)) / (PI * n))
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values.times ideal_filter
        @fft = FFT.new(data: self.weights)
        @fft.calculate
    end
end