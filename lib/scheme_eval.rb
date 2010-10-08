module Scheme
    @evaluation_handlers = []

    # self evaluating
    @evaluation_handlers.push([
        lambda do |exp, env| 
            [Numeric, String, TrueClass, FalseClass].map do |type|
                exp.is_a? type
            end.any?
        end,

        lambda do |exp, env|
            exp
        end
    ])

    # var lookup
    @evaluation_handlers.push([
        lambda do |exp, env|
            exp.is_a? Symbol
        end,

        lambda do |exp, env|
            env.get(exp)
        end
    ])

    def self.evaluate(expression, env)

        @evaluation_handlers.each do |pred, handler|
            if pred[expression, env]
                return handler[expression, env]
            end
        end

        raise "Cannot evaluate %{expression}"
    end

    def self.run(code, env=nil)
        default_env = Environment.new
        ast = parse code

        if env
            default_env = default_env.extend env
        end

        # default_env.set('+', NativeProc...)

        return evaluate(ast, default_env)
    end
end
