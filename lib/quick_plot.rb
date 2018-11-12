class Dsp::QuickPlot

    extend Dsp::Plottable::ClassMethods

    def self.plot(x: nil,y: nil, data: nil, title: nil, x_label: nil, y_label: nil, labels: nil)
        raise ArgumentError.new("Either x and y or data must exist") if data.nil? and (x.nil? or y.nil?)
        qplot(x: x, y: y, data: data) do |g|
            g.title = title if not title.nil?
            g.x_axis_label = x_label if not x_label.nil?
            g.y_axis_label = y_label if not y_label.nil?
            g.labels = labels if not labels.nil?
        end
    end

    def pi_plot(label ="0.5")
        z = zeros(26)
        o = ones(50)
        y = z + o + z
        x = linspace(-2, 2, 102)
        plot(x: x, y: y, title: "PI fn" ,labels: {-1 => "-#{label}", 0 => "0", 1 => label}) 
    end
    
    def lambda_plot(label = "1")
        eqn = ->(t){ t.abs <= 1 ? (1 - t.abs) : 0}
        x = linspace(-2, 2, 102)
        plot(data: x.map{|t| eqn.call(t)},title: "Lambda fn" ,labels: {26 => "-#{label}", 51 => 0 ,76 => label}) 
    end

    def self.plot_eq(eqn: , sample_times: ,title: nil, x_label: nil, y_label: nil)
        data = process(eqn, sample_times)
        plot(data: data, title: title, x_label: x_label, y_label: y_label)
    end

    def process(eqn, locations)
        locations.map{ |n| eqn.call(n) }
    end

end