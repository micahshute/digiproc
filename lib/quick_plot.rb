class Dsp::QuickPlot

    extend Dsp::Plottable::ClassMethods


    def self.plot(x: nil,y: nil, data: nil, title: nil, x_label: nil, y_label: nil, labels: nil, data_name: "data", label_map: nil, dark: false)
        xyname, dataname = nil, nil
        if not x.nil?
            if evenly_spaced?(x)
                label_map = Dsp::Functions.map_to_eqn(0, x.length, x.min, x.max)
                data = y
                y, x = nil, nil
            end
        end
        data.nil? ? (xyname = data_name) : (dataname = data_name)
        qplot(x: x, y: y, data: data, data_name: dataname, xyname: xyname, label_map: label_map, filename: to_filename(title)) do |g|
            g.title = title if not title.nil?
            g.x_axis_label = x_label if not x_label.nil?
            g.y_axis_label = y_label if not y_label.nil?
            g.labels = labels if not labels.nil?
            g.theme = Dsp::Plottable::Styles::MIDNIGHT if dark
        end
    end

    def self.step()
    end

    def self.pi_plot(label ="0.5")
        z = Dsp::Functions.zeros(26)
        o = Dsp::Functions.ones(50)
        y = z + o + z
        x = Dsp::Functions.linspace(-2, 2, 102)
        plot(x: x, y: y, title: "PI fn" ,labels: {-1 => "-#{label}", 0 => "0", 1 => label}) 
    end
    
    def self.lambda_plot(label = "1")
        eqn = ->(t){ t.abs <= 1 ? (1 - t.abs) : 0}
        x = Dsp::Functions.linspace(-2, 2, 102)
        plot(data: x.map{|t| eqn.call(t)},title: "Lambda fn" ,labels: {26 => "-#{label}", 51 => 0 ,76 => label}) 
    end

    def self.plot_eq(eqn: , sample_times: ,title: nil, x_label: nil, y_label: nil)
        data = process(eqn, sample_times)
        plot(data: data, title: title, x_label: x_label, y_label: y_label)
    end

    def process(eqn, locations)
        locations.map{ |n| eqn.call(n) }
    end

    private

    def self.evenly_spaced?(data)
        interval = data[1] - data[0] 
        for i in 2...data.length do
            new_int = data[i] - data[i-1]
            return false if new_int.round(10) != interval.round(10)
        end
        true
    end

    def self.to_filename(title)
        title.downcase.gsub(" ", "_")
    end

end