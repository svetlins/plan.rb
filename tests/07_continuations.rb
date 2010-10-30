require "lib/scheme";
require "test/unit";

class TestContinuation < Test::Unit::TestCase
    def test_continuation
        assert_equal(
            35,
            Scheme::run("(call/cc (lambda (throw) 
                 (+ 5 (* 10 (call/cc (lambda (esc) (* 100 (esc 3))))))))"
            )
        )

        assert_equal(
            3,
            Scheme::run("(call/cc (lambda (throw) 
                 (+ 5 (* 10 (call/cc (lambda (escape) (* 100 (throw 3))))))))"
            )
        )
    end
end
