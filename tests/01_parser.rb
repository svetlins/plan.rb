require "lib/scheme";
require "test/unit";

class TestSchemeParser < Test::Unit::TestCase
    def test_knowledge
        assert_equal(42, Scheme::parse("42"))
        #assert_equal([1,2,3], Scheme::parse("(1 2 3)"));
    end

    def test_atoms
        assert_equal(0, Scheme::parse("0"))
        assert_equal(1, Scheme::parse("1"))
        assert_equal(42, Scheme::parse("42"))
        assert_equal(-42, Scheme::parse("-42"))
        assert_equal(69, Scheme::parse("+69"))

        assert_equal("test", Scheme::parse("\"test\""))
        assert_equal("test+-*=,.[]()", Scheme::parse("\"test+-*=,.[]()\""))
        assert_equal("+-*=,.[]()", Scheme::parse("\"+-*=,.[]()\""))
    end

    def test_lists
        assert_equal(1, Scheme::parse("(1 2 3)").car)
        assert_equal(2, Scheme::parse("(1 2 3)").cdr.car)
        assert_equal(3, Scheme::parse("(1 2 3)").cdr.cdr.car)
        assert_equal(nil, Scheme::parse("(1 2 3)").cdr.cdr.cdr)
        assert_equal(4, Scheme::parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.car.car)
        assert_equal(nil, Scheme::parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr)
        assert_equal(42, Scheme::parse("(((42)))").car.car.car)

        assert_equal(nil, Scheme::parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr)
        assert_equal(1, Scheme::parse("(1 2 3 (4 5 6 (1 (1 (1 (1))))))").cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.cdr.car.car)
    end


    def test_symbols
        assert_equal(true, Scheme::parse("(#t #f)").car)
        assert_equal(false, Scheme::parse("(#t #f)").cdr.car)

        assert_equal(:a, Scheme::parse('a'))
        assert_equal(:'call/cc', Scheme::parse("call/cc"))

        assert_equal(4, Scheme::parse("(4 symbol other 5)").car)
        assert_equal(:symbol, Scheme::parse("(symbol symbol)").car)
        assert_equal(:abv, Scheme::parse("(quote abv)").cdr.car)

        assert_equal(:null?, Scheme::parse("(null? nil)").car)
        assert_equal(:'hyphenated-stuff', Scheme::parse("(hyphenated-stuff nil)").car)

        assert_equal(:a, Scheme::parse('(a)').car)

        assert_equal(nil, Scheme::parse("nil"))
        assert_equal(nil, Scheme::parse("()"))
        assert_equal(nil, Scheme::parse("(cons 1 nil)").cdr.cdr.car)
        assert_equal(:cons, Scheme::parse("(cons 1 2)").car)
        assert_equal(:cons, Scheme::parse("(cons 1 (cons 1 2))").cdr.cdr.car.car)
        assert_equal(:cons, Scheme::parse("((cons 1  2) (cons 1 2))").cdr.car.car)

        assert_equal(Scheme::Pair, Scheme::parse("(begin (define proc1 (lambda (x) (define proc2 (lambda (y) (+ x y))) (proc2 7))) (proc1 10))").class)
    end
end
