module Dsp::Initializable
    def self.included(base)
        base.class_eval do 
            def initialize_modules(*modules)
                modules.each do |m|
                    if verify_params(m) == :valid_hash
                       m.keys.first.instance_method(:initialize).bind(self).call(m.values.first)
                    elsif verify_params(m) == :valid_module
                        m.instance_method(:initialize).bind(self).call
                    end
                end
            end

            private

            def verify_params(item)
                return :valid_module if item.is_a? Module
                if item.is_a? Hash
                    return :valid_hash if item.keys.length == 1 and item.keys.first.is_a? Module
                end
                raise ArgumentError.new("Each argument must either be a module or a hash of type Module => args")
            end

        end
    end

   
end