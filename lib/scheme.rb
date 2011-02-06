require 'scheme/types'
require 'scheme/parser'
require 'scheme/environment'
require 'scheme/globals'
require 'scheme/evaluator'

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
            begin
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
            rescue StandardError => e
              puts "!-> #{e}"
            end
        end
    end
end
