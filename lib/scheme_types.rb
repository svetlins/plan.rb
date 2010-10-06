module SchemeTypes

    class SchemeTypes::Pair
        attr_reader :car, :cdr

        def initialize(car, cdr)
            @car, @cdr = car, cdr
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
        
