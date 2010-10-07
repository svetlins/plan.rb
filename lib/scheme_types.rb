module Scheme

    class Pair
        attr_reader :car, :cdr

        def initialize(car, cdr)
            @car, @cdr = car, cdr
        end

        def map &block
            if @cdr
                Pair.new(yield(@car), @cdr.map(&block))
            else
                Pair.new(yield(@car), nil)
            end
        end

        def zip other
            if @cdr
                [[@car, other.car]] + @cdr.zip(other.cdr)
            else
                [[@car, other.car]]
            end
        end
    end

    # ----
    private

    def self._make_linked_list_iter(iter, list)
        if list.size == 0 then
            iter
        else
            _make_linked_list_iter(Pair.new(list[0], iter), list[1..-1])
        end
    end

    # ----
    public

    def self.make_linked_list(list)
        _make_linked_list_iter(nil, list.reverse)
    end
end
