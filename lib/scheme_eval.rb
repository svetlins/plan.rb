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

    def self.procedure_call? exp
        # very naive
        not_relevant = [
            :if,
            :begin,
            :define,
            :+,
            :-,
            :*,
            :'=',
        ]
        exp.is_a? Pair and not not_relevant.member? exp.car
    end

    def self.evaluate_proc_body exp, env
        if exp.cdr
            evaluate(exp.car, env)
            evaluate_proc_body(exp.cdr, env)
        else
            # this is the last expression
            # it is in else because it's value is the value
            # of the procedure, and because it should be 
            # analyzed for tail call
            last_exp = exp.car
            
            # analyze for tail call
            if last_exp.is_a? Pair
                if procedure_call? last_exp
                    throw :tailcall, [last_exp, env]
                elsif last_exp.car == :if
                    return evaluate(last_exp, env)
                end
            end
                
            return evaluate(last_exp, env)
        end
    end

    def self.values_list values, env
        if values
            Pair.new(evaluate(values.car, env), values_list(values.cdr, env))
        else
            nil
        end
    end

    @evaluation_handlers = []
    @in_procedure = []

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

    eval_app = lambda do |exp, env|
            new_exp,new_env = catch :tailcall do
                procedure_exp = exp.car
                arg_exps = exp.cdr

                # evaluate procedure
                procedure = evaluate(procedure_exp, env)

                # evaluate arguments left to right
                arguments = values_list(arg_exps, env)

                # apply
                result = procedure.apply arguments

                return result
            end

            return [new_exp, new_env]
    end

    # proc evaluation!
    @evaluation_handlers.push([
        lambda do |exp|
            exp.is_a? Pair
        end,
        lambda do |exp, env|
            result = eval_app[exp, env]

            while result.is_a? Array
                result = eval_app[*result]
            end

            result
        end
        #lambda do |exp, env|
        #    evaluate_application = lambda do |exp, env|
        #        procedure_exp = exp.car
        #        arg_exps = exp.cdr

        #        # evaluate procedure
        #        procedure = evaluate(procedure_exp, env)

        #        # evaluate arguments left to right
        #        arguments = values_list(arg_exps, env)

        #        # apply
        #        result = procedure.apply arguments

        #        return result
        #    end

        #    new_exp,new_env = catch :tailcall do
        #        return evaluate_application[exp, env]
        #    end

        #    return evaluate_application[new_exp, new_env]
        #end
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
