## 
# kaiser Window
# Used to improve digital filters by using a non-retangular frequency domain window 
# NOT COMPLETE
# TODO: Finish this Window
class Digiproc::KaiserWindow < Digiproc::WindowStrategy
    
    
    def initialize(size: , stopband_db: nil, beta: nil)
        raise ArgumentError.new("Must have a stopband or a beta") if stopband_db.nil? && beta.nil?
        super(size: size)
        size = @size
        @equation = lambda { |n|  }
        calculate
        @values = @values.take(@size)
    end

    def beta_for_db(db)
        if db <= 21
            return 0
        elsif db < 50
            return 0.5842*((db - 21) ** 0.4) + 0.07886 * (db - 21)
        else
            return 0.1102*(db - 8.7)
        end
    end
end
