require "lib/scheme";
require "test/unit";

class TestLinkedLists < Test::Unit::TestCase
    def setup
        @linked_list = Scheme::make_linked_list([1,2,3,4])
    end

    def test_map
        squares = @linked_list.map { |e| e ** 2 }
        assert_equal(1, squares.car)
        assert_equal(16, squares.cdr.cdr.cdr.car)
    end

    def test_zip
        squares = @linked_list.map { |e| e ** 2 }
        cubes = @linked_list.map { |e| e ** 3 }

        zipped = squares.zip(cubes)

        assert_equal([1,1], zipped[0])
        assert_equal([4,8], zipped[1])
        assert_equal([9,27], zipped[2])
    end

    def test_array_to_linked
        linked_list = Scheme::make_linked_list([1,2,3,4])

        assert_equal(1, linked_list.car)
        assert_equal(4, linked_list.cdr.cdr.cdr.car)
        assert_equal(nil, linked_list.cdr.cdr.cdr.cdr)
    end

    def test_linked_to_array
        array = Scheme::make_array(
            Scheme::Pair.new(1,
                Scheme::Pair.new(2,
                    Scheme::Pair.new(3, nil)
                )
            )
        )

        assert_equal([1,2,3], array)

        array = Scheme::make_array(
            Scheme::Pair.new(1,
                Scheme::Pair.new(Scheme::Pair.new(42, Scheme::Pair.new(69, nil)),
                    Scheme::Pair.new(3, nil)
                )
            )
        )

        assert_equal([1, [42, 69], 3], array)

    end
end
