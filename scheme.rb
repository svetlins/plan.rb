require 'treetop'
require 'scheme_grammar'

module Scheme
    def self.scheme_parse(stuff)
        SchemeGrammarParser.new.parse(stuff).value
    end
end
