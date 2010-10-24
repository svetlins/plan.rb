require "lib/scheme";
require "test/unit";

class TestPrint < Test::Unit::TestCase
    def test_print_atoms
        assert_equal('1', Scheme::parse('1').to_s)
        assert_equal('-42', Scheme::parse('-42').to_s)
        assert_equal('"str"', Scheme::parse('"str"').to_s)
    end

    def test_print_llist
        assert_equal('(1 2 3)', Scheme::parse('(1 2 3)').to_s)
        assert_equal('(1 2 3 (4 5 6))', Scheme::parse('(1 2 3 (4 5 6))').to_s)
        assert_equal('(1)', Scheme::parse('(1)').to_s)
        assert_equal('(+ 1 2)', Scheme::parse('(+ 1 2)').to_s)
        assert_equal('(null? 5)', Scheme::parse('(null? 5)').to_s)

        assert_equal(
            '(1 2 3)',
            Scheme::run('(cons 1 (cons 2 (cons 3 nil)))').to_s
        )
    end

    def test_print_pair
        assert_equal('(1 . 2)', Scheme::run('(cons 1 2)').to_s)
        assert_equal('(99 . "str")', Scheme::run('(cons (+ 33 66) "str")').to_s)
    end

    def test_print_nil
        assert_equal('(null? nil)', Scheme::parse('(null? nil)').to_s)
        assert_equal('(null? nil)', Scheme::parse('(null? ())').to_s)
    end
end
