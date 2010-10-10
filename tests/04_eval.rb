require 'test/unit'
require 'lib/scheme'

class EvaluatorTests < Test::Unit::TestCase
    def test_pairs
        assert_equal(1, Scheme::Pair.new(1, 2).car)
        assert_equal(2, Scheme::Pair.new(1, 2).cdr)
    end

    def test_ll
        list = Scheme::Pair.new(1, Scheme::Pair.new(2, Scheme::Pair.new(3, nil)))

        assert_equal(1, list.car)
        assert_equal(2, list.cdr.car)
        assert_equal(3, list.cdr.cdr.car)
    end

    def test_self_evaluating
        assert_equal(1, Scheme::run("1"))
        assert_equal("svetlin", Scheme::run("\"svetlin\""))
        assert_equal(true, Scheme::run("#t"))
        assert_equal(false, Scheme::run("#f"))
    end

    def test_var_lookup
        env_var = {:var => 42}
        assert_equal(42, Scheme::run("var", env_var))
    end

    def test_quote
        assert_equal(:a, Scheme::run("(quote a)"))
        assert_equal(1, Scheme::run("(quote (1 2 3))").car)
        assert_equal(3, Scheme::run("(quote (1 2 3))").cdr.cdr.car)
    end

    def test_begin
        assert_equal(3, Scheme::run("(begin 1 2 3)"))

        env_var = {:var => 42}

        assert_equal(42, Scheme::run("(begin var)", env_var))
    end

    def test_set
        assert_equal(69, Scheme::run("(begin (set! a 69) a)"))
    end

    def test_define
        assert_equal(42, Scheme::run("(begin (define a 42) a)"))
    end

    def test_if
        assert_equal("baba", Scheme::run("(if #t \"baba\" \"dyado\")"))
        assert_equal("dyado", Scheme::run("(if #f \"baba\" \"dyado\")"))

        # no else clause
        assert_equal(nil, Scheme::run("(if #f \"baba\")"))
    end

    def test_lambda
        assert_equal(42, Scheme::run("((lambda (x) x) 42)"))
        assert_equal(1337, Scheme::run("(begin (define myproc (lambda (x) x)) (myproc 1337))"))
    end

    def test_operations
        assert_equal(2, Scheme::run("(+ 1 1)"))
        assert_equal(3, Scheme::run("(+ 1 (+ 1 1))"))
        assert_equal(41, Scheme::run("(- 42 1)"))
        assert_equal(8, Scheme::run("(* 2 (* 2 2))"))
        assert_equal(true, Scheme::run("(= 1 1)"))
        assert_equal(false, Scheme::run("(= 1 2)"))
        assert_equal(3628800, Scheme::run("(begin (define fact (lambda (n) (if (= n 1) 1 (* n (fact (- n 1)))))) (fact 10))"))
    end

    # def test_old
    #     assert_equal(Scheme::run("(if #t 1 2)"), 1)
    #     assert_equal(Scheme::run("(if #f 1 2)"), 2)
    # end

    # def test_cons
    #     assert_equal(Scheme::run("(cons 1 2)").car, 1)
    #     assert_equal(Scheme::run("(cons 1 2)").cdr, 2)
    #     assert_equal(Scheme::run("(cons 1 nil)").cdr, SchemeSymbol.new('nil'))
    #     assert_equal(Scheme::run("(cons 1 (cons 2 nil))").car, 1)
    #     assert_equal(Scheme::run("(cons 1 (cons 2 nil))").cdr.car, 2)
    #     assert_equal(Scheme::run("(cons 1 (cons 2 nil))").cdr.cdr, SchemeSymbol.new('nil'))
    # end

    # def test_car_cdr
    #     assert_equal(Scheme::run("(car (cons 1 2))"), 1)
    #     assert_equal(Scheme::run("(cdr (cons 1 2))"), 2)
    #     assert_equal(Scheme::run("(car (cdr (cdr (cons 1 (cons 2 (cons 3 nil))))))"), 3)
    # end

    # def test_null
    #     assert_equal(Scheme::run("(null? nil)"), True)
    #     assert_equal(Scheme::run("(null? 5)"), False)
    # end

    # def test_complex
    #     my $begin-func = "
    #         (begin (define proc 
    #                        (lambda (x)
    #                                (+ x 11)))
    #                (proc 30))
    #     "

    #     assert_equal(Scheme::run($begin-func.replace("\n", '')), 41)

    #     my $complex-program = "
    #         (begin (define proc1
    #                       (lambda (x) 
    #                               (define proc2 
    #                                       (lambda (y) (+ x y))) 
    #                               (proc2 7))) 
    #                (proc1 10))
    #     "
    #     
    #     $complex-program = $complex-program.subst(rx/ \s+ /, ' ', :g).trim
    #     assert_equal(Scheme::run($complex-program), 17)
    # end
end
