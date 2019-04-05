## 
# Deternine the OS for classes which need to perform system commands
module Dsp::OS


    ## 
    # return true if in a windows env
    def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
    
    ## 
    # return true if in a mac env
    def mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end
    
    ## 
    # return true if in a unix env
    def unix?
        !windows?
    end
    
    ## 
    # return true if in a linux env
    def linux?
        unix? and not mac?
    end
    
    ## 
    # return true if using jruby
    def ruby?
        RUBY_ENGINE == 'jruby'
    end

end