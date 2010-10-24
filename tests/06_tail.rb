require "lib/scheme";
require "test/unit";

class TestTail < Test::Unit::TestCase
    def test_tail_elimination
        assert_equal(
            10000,
            Scheme::run("(begin (define 
                                    proc 
                                    (lambda (x) 
                                        (if (= x 10000)
                                            x 
                                            (proc  (+ x 1)))))
                                (proc 1))"
            )
        )

        assert_equal(
            42,
            Scheme::run("(begin (define 
                                    proc 
                                    (lambda (x) 
                                        (if (= x 10000)
                                            42 
                                            (proc  (+ x 1)))))
                                (proc 1))"
            )
        )

        # can't do tail call elimination here
        # so expect stack depletion
        assert_raise SystemStackError do 
            Scheme::run("(begin (define
                                    proc
                                    (lambda (x)
                                        (if (= x 1000)
                                            42
                                            (+ 1 (proc (+ x 1))))))
                                (proc 1))"
            )
        end
    end
end
