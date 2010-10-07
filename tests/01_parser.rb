require "lib/scheme";
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
        assert_equal(1, Scheme::scheme_parse("(1 2 3)").car)
        assert_equal(2, Scheme::scheme_parse("(1 2 3)").cdr.car)
        assert_equal(3, Scheme::scheme_parse("(1 2 3)").cdr.cdr.car)
        assert_equal(nil, Scheme::scheme_parse("(1 2 3)").cdr.cdr.cdr)
        assert_equal(4, Scheme::scheme_parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.car.car)
        assert_equal(nil, Scheme::scheme_parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr)
        assert_equal(42, Scheme::scheme_parse("(((42)))").car.car.car)

        assert_equal(nil, Scheme::scheme_parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr)
        assert_equal(1, Scheme::scheme_parse("(1 2 3 (4 5 6 (1 (1 (1 (1))))))").cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.cdr.car.car)
    end


    def test_symbols
        assert_equal(Scheme::scheme_parse("(#t #f)").car , true)
        assert_equal(Scheme::scheme_parse("(#t #f)").cdr.car , false)

        assert_equal(4, Scheme::scheme_parse("(4 symbol other 5)").car)
        assert_equal(:symbol, Scheme::scheme_parse("(symbol symbol)").car)
        assert_equal(Scheme::scheme_parse("(quote abv)").cdr.car, :abv)

        assert_equal(Scheme::scheme_parse("(null? nil)").car, :null?)

        assert_equal(Scheme::scheme_parse('(a)').car, :a)

        assert_equal(Scheme::scheme_parse("nil"), nil)
        assert_equal(Scheme::scheme_parse("(cons 1 nil)").cdr.cdr.car, nil)
        assert_equal(Scheme::scheme_parse("(cons 1 2)").car, :cons)
        assert_equal(Scheme::scheme_parse("(cons 1 (cons 1 2))").cdr.cdr.car.car, :cons)
        assert_equal(Scheme::scheme_parse("((cons 1  2) (cons 1 2))").cdr.car.car, :cons)

        assert_equal(Scheme::scheme_parse("(begin (define proc1 (lambda (x) (define proc2 (lambda (y) (+ x y))) (proc2 7))) (proc1 10))").class, Scheme::Pair)
    end
end
