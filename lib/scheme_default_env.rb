module Scheme
        @global_env = Environment.new

        #populate global environment with built-in procedures
        @global_env.set(
            :+,
            NativeProcedure.new(lambda { |_| _.car + _.cdr.car })
        )

        @global_env.set(
            :*,
            NativeProcedure.new(lambda { |_| _.car * _.cdr.car })
        )

        @global_env.set(
            :-,
            NativeProcedure.new(lambda { |_| _.car - _.cdr.car })
        )

        @global_env.set(
            :'=',
            NativeProcedure.new(lambda { |_| _.car == _.cdr.car })
        )

        @global_env.set(
            :cons,
            NativeProcedure.new(lambda { |_| Pair.new(_.car, _.cdr.car) })
        )

        @global_env.set(
            :car,
            NativeProcedure.new(lambda { |_| _.car.car })
        )

        @global_env.set(
            :cdr,
            NativeProcedure.new(lambda { |_| _.car.cdr })
        )

        @global_env.set(
            :null?,
            NativeProcedure.new(lambda { |_| _.car.nil? })
        )

        @global_env.set(
            :display,
            NativeProcedure.new(lambda { |_| puts _.car.to_s })
        )
end
