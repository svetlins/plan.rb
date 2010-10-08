require 'treetop'
require 'lib/scheme_types'
require 'lib/scheme_grammar'
require 'lib/scheme_env'

module Scheme
    def self.scheme_parse(stuff)
        SchemeGrammarParser.new.parse(stuff).value
    end
end
