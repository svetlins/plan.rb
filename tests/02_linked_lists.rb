require "lib/scheme";
require "test/unit";

class TestLinkedLists < Test::Unit::TestCase
    def setup
        @flat_list = [1,2,3,4]
    end

    def test_construct
        linked_list = Scheme::make_linked_list(@flat_list)

        assert_equal(1, linked_list.car)
        assert_equal(4, linked_list.cdr.cdr.cdr.car)
        assert_equal(nil, linked_list.cdr.cdr.cdr.cdr)
    end

    def test_map
        squares = Scheme::make_linked_list(@flat_list).map { |e| e ** 2 }
        assert_equal(1, squares.car)
        assert_equal(16, squares.cdr.cdr.cdr.car)
    end

    def test_zip
        squares = Scheme::make_linked_list(@flat_list).map { |e| e ** 2 }
        cubes = Scheme::make_linked_list(@flat_list).map { |e| e ** 3 }

        zipped = squares.zip(cubes)

        assert_equal([1,1], zipped[0])
        assert_equal([4,8], zipped[1])
        assert_equal([9,27], zipped[2])
    end
end
