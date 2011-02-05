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

        assert_equal([1, Scheme::Pair.new(42, Scheme::Pair.new(69, nil)), 3], array)

        assert_equal([1], Scheme::make_array(Scheme::Pair.new(1,nil)))

        assert_equal(
            [Scheme::Pair.new(1,2)],
            Scheme::make_array(
                Scheme::Pair.new(Scheme::Pair.new(1,2), nil)
            )
        )
    end

    def test_transform
        array_to_list = lambda do |array|
            assert_equal array, Scheme::make_array(Scheme::make_linked_list(array))
        end

        array_to_list[[1,2,3]]
        array_to_list[[]]
        array_to_list[[1]]

        array_to_list[[Scheme::Pair.new(1,2), Scheme::Pair.new(42,69)]]

        list_to_array = lambda do |list|
            assert_equal list, Scheme::make_linked_list(Scheme::make_array(list))
        end

        list_to_array[
            Scheme::Pair.new(1,Scheme::Pair.new(2,Scheme::Pair.new(3, nil)))
        ]

        list_to_array[
            Scheme::Pair.new(1,nil)
        ]
    end
end
