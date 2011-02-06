module Scheme

    class Pair
        attr_reader :car, :cdr

        def initialize(car, cdr)
            @car, @cdr = car, cdr
        end

        # list related
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

        def to_scheme
            if @cdr.is_a? Pair or @cdr.is_a? NilClass
                # assume linked list and print the whole list
                current = self
                result = []

                while current
                    result.push(current.car.to_scheme)
                    current = current.cdr
                end

                return '(' + result.join(' ') + ')'
            else
                # assume just a single pair
                return '(' + @car.to_scheme + ' . ' + @cdr.to_scheme + ')'
            end
        end

        def ==(other)
            if other.is_a? Pair
                return (@car == other.car) && (@cdr == other.cdr)
            else
                return false
            end
        end
    end

    class Procedure
        def initialize params, exps, env
            @params, @exps, @env = params, exps, env
        end

        def apply args
            bindings = {}
            if @params
                @params.zip(args).each do |k,v|
                    bindings[k] = v
                end
            end

            Exp.new(@exps).evaluate_proc_body @env.extend(bindings)
        end

        def to_scheme
          p = Scheme.make_array(@params).map &:to_scheme
          e = Scheme.make_array(@exps).map &:to_scheme

          "(lambda (#{p.join}) #{e.join})"
        end
    end

    class NativeProcedure
        def initialize procedure
            @procedure = procedure
        end

        def apply args
            args_array = Scheme::make_array args
            return @procedure.call(*args_array)
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

    def self.make_array_deep(linked_list)
        if linked_list
            head, rest = linked_list.car, linked_list.cdr

            if head.is_a? Pair
                if head.cdr.is_a? Pair or head.cdr == nil
                    head = make_array head
                end
            end

            rest = make_array rest

            return [head] + rest
        else
            return []
        end
    end

    def self.make_array(linked_list)
        if linked_list
            head, rest = linked_list.car, linked_list.cdr

            return [linked_list.car] + make_array(rest)
        else
            return []
        end
    end
end

class NilClass
    def to_scheme
        "nil"
    end
end

class String
    def to_scheme
        '"' + to_s + '"'
    end
end

class TrueClass
  def to_scheme
    '#t'
  end
end

class FalseClass
  def to_scheme
    '#f'
  end
end

class Object
  def to_scheme
    to_s
  end
end
