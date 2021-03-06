require 'plan/types'
require 'plan/parser'
require 'plan/environment'
require 'plan/globals'
require 'plan/expression'

module Plan
  def self.run(code, env=nil)
    # parse code
    ast = Parser.new.parse code

    # apply any given bindings to global env
    if env
      current_env = @global_env.extend env
    else
      current_env = @global_env
    end

    return Exp.new(ast).evaluate current_env
  end

  def self.shutdown
    puts 'Bye!'
    exit(0)
  end

  def self.repl
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
        puts result.plan_inspect

        #loop
      rescue Interrupt
        puts
        puts 'keyboard interrupt'
      rescue EOFError
        shutdown
      rescue StandardError => e
        puts "!-> #{e}"
      end
    end
  end
end
