plt = Dsp::QuickPlot

def zeros(num)
    Array.new(num, 0)
end

def ones(num)
    Array.new(num, 1)
end

def linspace(start, stop, number)
    rng = 0...number
    interval = (stop - start).to_f / (number - 1)
    rng.map{ |val| start + interval * val }
end



pi_plot("B")

# binding.pry
