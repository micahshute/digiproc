##
# Class for quickly plotting data
class Digiproc::QuickPlot

    extend Digiproc::Plottable::ClassMethods



    ##
    # Quickly plot data. Either data OR x AND y are required. If just data is inputted, x values will be the index of the value in the data array
    # == Input Args
    # x:: Array[Numeric] (required if data is not included)
    # y:: Array[Numeric] (required if data is not included)
    # data:: Array[Numeric] (required if x and y are not included)
    # title (Optional):: String
    # x_label (Optional):: String
    # y_label (Optional):: String
    # labels (Optional):: Array[String] x value labels
    # data_name (Optional):: name of data for legend
    # label_map (Optional):: Lambda - mapping data index to an x label for that index
    # dark (Optional):: Boolean - whether or not to use dark mode (defaults to false)
    # path (Optional):: Path to save plot picture to. Defauilts to "./plots"
    def self.plot(x: nil,y: nil, data: nil, title: nil, x_label: nil, y_label: nil, labels: nil, data_name: "data", label_map: nil, dark: false, path: "./plots/")
        xyname, dataname = nil, nil
        if not x.nil?
            if evenly_spaced?(x)
                label_map = Digiproc::Functions.map_to_eqn(0, x.length, x.min, x.max)
                data = y
                y, x = nil, nil
            end
        end
        data.nil? ? (xyname = data_name) : (dataname = data_name)
        qplot(x: x, y: y, data: data, data_name: dataname, xyname: xyname, label_map: label_map, filename: to_filename(title), path: path) do |g|
            g.title = title if not title.nil?
            g.x_axis_label = x_label if not x_label.nil?
            g.y_axis_label = y_label if not y_label.nil?
            g.labels = labels if not labels.nil?
            g.theme = Digiproc::Plottable::Styles::MIDNIGHT if dark
        end
    end

    def self.step()
    end

    ##
    # Plots a pi plot
    def self.pi_plot(label ="0.5")
        z = Digiproc::Functions.zeros(26)
        o = Digiproc::Functions.ones(50)
        y = z + o + z
        x = Digiproc::Functions.linspace(-2, 2, 102)
        plot(x: x, y: y, title: "PI fn" ,labels: {-1 => "-#{label}", 0 => "0", 1 => label}) 
    end
    

    ##
    # Plots a lambda plot
    def self.lambda_plot(label = "1")
        eqn = ->(t){ t.abs <= 1 ? (1 - t.abs) : 0}
        x = Digiproc::Functions.linspace(-2, 2, 102)
        plot(data: x.map{|t| eqn.call(t)},title: "Lambda fn" ,labels: {26 => "-#{label}", 51 => 0 ,76 => label}) 
    end

    ##
    # Plots an input equation (lambda)
    # == Input args
    # eqn:: lambda, equation to pe plotted
    # sample_times:: Array[Numeric] input values to lambda equation
    # title (Optional):: String
    # x_label (Optional):: String
    # y_label (Optional):: String
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
        title.nil? ? "Quickplot Graph" : title.downcase.gsub(" ", "_")
    end

end