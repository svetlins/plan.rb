require 'rubygems'
require 'treetop'
require 'scheme/grammar'

class SchemeInterpreter
  def parse(code)
    SchemeGrammarParser.new.parse(code).value
  end
end

module Scheme
    def self.parse(code)
      SchemeInterpreter.new.parse(code)
    end

    def self.clean_code(code)
        while code.count("\n") > 0
            code.sub!("\n", ' ')
        end

        cleaned_code = code.strip.sub(/\s{2,}/, ' ')
        while cleaned_code != code
            code = cleaned_code
            cleaned_code = code.sub(/\s{2,}/, ' ')
        end

        return cleaned_code
    end

end
