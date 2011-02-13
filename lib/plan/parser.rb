require 'rubygems'
require 'treetop'
require 'plan/grammar'

module Plan
  class Parser
    def parse(code)
      SchemeGrammarParser.new.parse(clean code).value
    end

    def clean(code)
      code.strip!
      code.gsub! /\n/, ' '
      code.gsub! /\s{1,}/, ' '
      code.gsub! /\(\s*/, '('
      code.gsub! /\s*\)/, ')'
      code
    end

  end
end
