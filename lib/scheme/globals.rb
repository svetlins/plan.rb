module Scheme
        @global_env = Environment.new

        #populate global environment with built-in procedures
        @global_env.set(
            :+,
            NativeProcedure.new(lambda { |a,b| a + b })
        )

        @global_env.set(
            :*,
            NativeProcedure.new(lambda { |a,b| a * b })
        )

        @global_env.set(
            :-,
            NativeProcedure.new(lambda { |a,b| a - b })
        )

        @global_env.set(
            :'=',
            NativeProcedure.new(lambda { |a,b| a == b })
        )

        @global_env.set(
            :cons,
            NativeProcedure.new(lambda { |a, b| Pair.new(a, b) })
        )

        @global_env.set(
            :car,
            NativeProcedure.new(lambda { |pair| pair.car })
        )

        @global_env.set(
            :cdr,
            NativeProcedure.new(lambda { |pair| pair.cdr })
        )

        @global_env.set(
            :null?,
            NativeProcedure.new(lambda { |a| a.nil? })
        )

        @global_env.set(
            :display,
            NativeProcedure.new(lambda { |a| puts a.to_s })
        )
        
end
