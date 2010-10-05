require 'rubygems'
require 'treetop'
require 'test_grammar'
require 'test/unit'


class TestSchemeParser < Test::Unit::TestCase
    def test_basic
        assert(
            TestGrammarParser.new.parse("1 2 3 a b c")
        )
    end

    def test_methods
        assert_equal(
            [1,2,3,'A','B','C'],
            TestGrammarParser.new.parse("1 2 3 a b c").value
        )
    end

            
end
