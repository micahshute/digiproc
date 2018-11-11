class Dsp::QuickPlot

    extend Dsp::Plottable::ClassMethods

    def self.plot(x: nil,y: nil, data: nil, title: nil, x_label: nil, y_label: nil)
        raise ArgumentError.new("Either x and y or data must exist") if data.nil? and (x.nil? or y.nil?)
        qplot(x: x, y: y, data: data) do |g|
            g.title = title if not title.nil?
            g.x_axis_label = x_label if not x_label.nil?
            g.y_axis_label = y_label if not y_label.nil?
        end
    end

    def self.plot_eq(eqn: , sample_times: ,title: nil, x_label: nil, y_label: nil)
        data = process(eqn, sample_times)
        plot(data: data, title: title, x_label: x_label, y_label: y_label)
    end

    def process(eqn, locations)
        locations.map{ |n| eqn.call(n) }
    end

end