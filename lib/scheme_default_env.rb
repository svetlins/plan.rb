module Scheme
        @default_env = Environment.new

        #populate default env
        @default_env.set(:+, NativeProcedure.new(lambda { |_| _.car + _.cdr.car }))
        @default_env.set(:*, NativeProcedure.new(lambda { |_| _.car * _.cdr.car }))
        @default_env.set(:-, NativeProcedure.new(lambda { |_| _.car - _.cdr.car }))
        @default_env.set(:'=', NativeProcedure.new(lambda { |_| _.car == _.cdr.car }))
        @default_env.set(:cons, NativeProcedure.new(lambda { |_| Pair.new(_.car, _.cdr.car) }))
        @default_env.set(:car, NativeProcedure.new(lambda { |_| _.car.car }))
        @default_env.set(:cdr, NativeProcedure.new(lambda { |_| _.car.cdr }))
        @default_env.set(:null?, NativeProcedure.new(lambda { |_| _.car.nil? }))
end
