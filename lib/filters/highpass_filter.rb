class HighpassFilter < DigitalFilter
    attr_accessor :equation

    def initialize(size:, window: RectangularWindow, wc: , correct: true)
        super(size: size, window: window)
        wc = wc - @window.transition_width * PI if correct
        @equation = ->(n){ 
            n == 0 ?  (( PI - wc) / PI) :  (-1 * (Math.sin( wc * n) / (PI * n)))
        }
        ideal_filter = calculate_ideal
        @weights = self.window.values * ideal_filter
        @fft = FFT.new(data: self.weights)
        @fft.calculate
    end

end