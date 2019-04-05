module Dsp::OS


    def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
    
    def mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end
    
    def unix?
        !OS.windows?
    end
    
    def linux?
        OS.unix? and not OS.mac?
    end
    
    def ruby?
        RUBY_ENGINE == 'jruby'
    end

end