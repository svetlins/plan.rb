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
            print "> "
            # read 
            code = readline
            while code.count('(') != code.count(')') do
                code += readline
            end

            # eval
            result = run code

            # print
            print '--> '
            puts result.to_scheme

            #loop
        end
    end
end

class NilClass
    def to_scheme
        "nil"
    end
end

class String
    def to_scheme
        '"' + to_s + '"'
    end
end

class TrueClass
  def to_scheme
    '#t'
  end
end

class FalseClass
  def to_scheme
    '#f'
  end
end

class Object
  def to_scheme
    to_s
  end
end
