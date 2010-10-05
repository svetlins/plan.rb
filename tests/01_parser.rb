require "scheme";
require "test/unit";

class TestSchemeParser < Test::Unit::TestCase
    def test_knowledge
        assert_equal(42, Scheme::scheme_parse("42"))
        #assert_equal([1,2,3], Scheme::scheme_parse("(1 2 3)"));
    end

    def test_atoms
        assert_equal(Scheme::scheme_parse("1"), 1)

        assert_equal(Scheme::scheme_parse("\"test\""), "test")
        assert_equal(Scheme::scheme_parse("\"test+-*=,.[]()\""), "test+-*=,.[]()")
        assert_equal(Scheme::scheme_parse("\"+-*=,.[]()\""), "+-*=,.[]()")
    end

    def test_lists
        assert_equal(1, Scheme::scheme_parse("(1 2 3)")[0])
        assert_equal(2, Scheme::scheme_parse("(1 2 3)")[1])
        assert_equal(3, Scheme::scheme_parse("(1 2 3)")[2])
        #assert_equal(Scheme::scheme_parse("(1 2 3)").cdr.cdr.cdr, SchemeSymbol.new('nil'))
        assert_equal(4, Scheme::scheme_parse("(1 2 3 (4 5 6))")[3][0])
        assert_equal(5, Scheme::scheme_parse("(1 2 3 (4 5 6))")[3][1])
        assert_equal(42, Scheme::scheme_parse("(((42)))")[0][0][0])
        p Scheme::scheme_parse("(1 2 3 (4 5 6))")
    end

    # is(scheme-parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr, SchemeSymbol.new('nil'));
    # is(scheme-parse("(1 2 3 (4 5 6 (1 (1 (1 (1))))))").cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.cdr.car.car, 1);

    # my $true_false = scheme-parse("(#t #f)");
    # is($true_false.car , True);
    # is($true_false.cdr.car , False);

    # my $quoted = scheme-parse("(quote abv)");
    # is($quoted.car, SchemeSymbol.new('quote'));
    # is($quoted.cdr.car, SchemeSymbol.new('abv'));

    # is(scheme-parse("(null? nil)").car, SchemeSymbol.new('null?'));

    # is(scheme-parse('(a)').car, SchemeSymbol.new('a'));

    # is(scheme-parse("nil"), SchemeSymbol.new('nil'));
    # is(scheme-parse("(cons 1 nil)").cdr.cdr.car, SchemeSymbol.new('nil'));
    # is(scheme-parse("(cons 1 2)").car, SchemeSymbol.new('cons'));
    # is(scheme-parse("(cons 1 (cons 1 2))").cdr.cdr.car.car, SchemeSymbol.new('cons'));
    # is(scheme-parse("((cons 1  2) (cons 1 2))").cdr.car.car, SchemeSymbol.new('cons'));

    # is(scheme-parse("(begin (define proc1 (lambda (x) (define proc2 (lambda (y) (+ x y))) (proc2 7))) (proc1 10))").WHAT, SPair);
end
