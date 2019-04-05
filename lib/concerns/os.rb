module Dsp::OS


    def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
    
    def mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end
    
    def unix?
        !windows?
    end
    
    def linux?
        unix? and not mac?
    end
    
    def ruby?
        RUBY_ENGINE == 'jruby'
    end

end