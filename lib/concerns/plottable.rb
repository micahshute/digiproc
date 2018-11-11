require 'gruff'
module Dsp::Plottable
    

    def plot(method:, filename: "plot_#{self.class}", path: "./", xmax: 1, xmin: 0, xsteps: 4)
        data = self.send(method)
        raise TypeError.new('Data must be an array, not a #{data.class}') if not data.is_a? Array
        g = Gruff::Line.new('1000x1000')
        g.line_width = 1
        g.dot_radius = 1
        g.minimum_x_value = 0
        g.data method, data
        increment_label = (xmax - xmin) / xsteps.to_f
        increment_datapoints = (data.length.to_f / xsteps).round
        labels = {}
        for i in 0..xsteps do
            datapoint_location = i * increment_datapoints
            datapoint_location -= 1 if datapoint_location > (data.length - 1)
            labels[datapoint_location] = (i * increment_label).round(2)
        end
        g.labels = labels
        g.show_vertical_markers = true
        yield g
        g.write(path + filename + '.png')
    end

end