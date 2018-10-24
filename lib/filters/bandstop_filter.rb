#for wo and bw, include the "don't care" areas in the bandstop area
class BandstopFilter < DigitalFilter
    attr_accessor :equation

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
        binding.pry
        @equation = ->(n){ 
            n == 0 ?  (wlp_upper / PI) + (( PI - whp_lower )/ PI ) : ((Math.sin(wlp_upper * n) - Math.sin(whp_lower * n)) / (PI * n))
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values * ideal_filter
        @fft = FFT.new(data: self.weights)
        @fft.calculate
    end
end