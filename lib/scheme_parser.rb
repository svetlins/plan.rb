require 'treetop'
require 'lib/scheme_grammar'

module Scheme
    def self.parse(stuff)
        SchemeGrammarParser.new.parse(stuff).value
    end
end
