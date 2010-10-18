module Scheme
    private

    def self.tagged_list? exp, tag
        exp.is_a? Pair and exp.car == tag.to_sym
    end

    def self.evaluate_list exp, env
        if exp.cdr
            evaluate(exp.car, env)
            evaluate_list(exp.cdr, env)
        else
            evaluate(exp.car, env)
        end
    end

    def self.values_list values, env
        if values
            Pair.new(evaluate(values.car, env), values_list(values.cdr, env))
        else
            # Pair.new(evaluate(values.car, env), :nil)
            nil
        end
    end

    @evaluation_handlers = []

    # self evaluating
    @evaluation_handlers.push([
        lambda do |exp| 
            [Numeric, String, TrueClass, FalseClass, NilClass].map do |type|
                exp.is_a? type
            end.any?
        end,

        lambda do |exp, env|
            exp
        end
    ])

    # var lookup
    @evaluation_handlers.push([
        lambda do |exp|
            exp.is_a? Symbol
        end,

        lambda do |exp, env|
            env.get(exp)
        end
    ])

    # quote
    @evaluation_handlers.push([
        lambda do |exp|
            tagged_list?(exp, 'quote')
        end,
        lambda do |exp, env|
            exp.cdr.car
        end
    ])

    # begin
    @evaluation_handlers.push([
        lambda do |exp|
            tagged_list?(exp, 'begin')
        end,
        lambda do |exp, env|
            evaluate_list(exp.cdr, env)
        end
    ])

    # define / set
    @evaluation_handlers.push([
        lambda do |exp|
            tagged_list?(exp, 'set!') or tagged_list?(exp, 'define')
        end,
        lambda do |exp, env|
            variable = exp.cdr.car
            value = evaluate(exp.cdr.cdr.car, env)

            env.set(variable, value)
        end
    ])

    # if
    @evaluation_handlers.push([
        lambda do |exp|
            tagged_list?(exp, 'if')
        end,
        lambda do |exp, env|
            predicate = exp.cdr.car
            true_conseq = exp.cdr.cdr.car

            if exp.cdr.cdr.cdr
                false_conseq = exp.cdr.cdr.cdr.car
            else
                false_conseq = :nil
            end

            if evaluate(predicate, env)
                evaluate(true_conseq, env)
            else
                evaluate(false_conseq, env)
            end
        end
    ])

    # lambda!
    @evaluation_handlers.push([
        lambda do |exp|
            tagged_list?(exp, 'lambda')
        end,
        lambda do |exp, env|
            var_list = exp.cdr.car
            exps = exp.cdr.cdr
            
            Procedure.new(var_list, exps, env)
        end
    ])

    # proc evaluation!
    @evaluation_handlers.push([
        lambda do |exp|
            exp.is_a? Pair
        end,
        lambda do |exp, env|
            procedure = exp.car
            args = exp.cdr
            
            evaluate(procedure, env).apply(values_list(args, env))
        end
    ])
    
    public

    def self.evaluate(expression, env)

        @evaluation_handlers.each do |pred, handler|
            if pred[expression]
                return handler[expression, env]
            end
        end

        raise "Cannot evaluate %s" % expression
    end

end
