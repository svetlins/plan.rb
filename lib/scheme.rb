require 'lib/scheme_types'
require 'lib/scheme_parser'
require 'lib/scheme_env'
require 'lib/scheme_default_env'
require 'lib/scheme_eval'

module Scheme
    def self.run(code, env=nil)
        # clean code
        cleaned_code = clean_code code

        # parse code
        ast = parse cleaned_code

        # apply any given bindings to global env
        if env
            current_env = @global_env.extend env
        else
            current_env = @global_env
        end

        return evaluate(ast, current_env)
    end

    def self.run_repl
        while true
            print ">"
            # read 
            code = readline

            # eval
            result = run code

            # print
            print '=>'
            puts result.to_s

            #loop
        end
    end
end

# some monkey patching
# I don't care what you think about it :)
# I've been too long into Python, now I appreciate the possibility
class NilClass
    def to_s
        "nil"
    end
end

# maybe this is a little bit too much
class String
    alias real_to_s to_s
    def to_s
        '"' + real_to_s + '"'
    end
end
