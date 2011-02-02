module Scheme
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
                    conseq_exp, conseq_env = eval_if_pred last_exp, env
                    
                    if procedure_call? conseq_exp
                        throw :tailcall, [conseq_exp, conseq_env]
                    end
                end
            end
                
            # not tail call, evaluate normally
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

    def self.eval_if_pred if_exp, env
        predicate = if_exp.cdr.car
        true_conseq = if_exp.cdr.cdr.car

        if if_exp.cdr.cdr.cdr
            false_conseq = if_exp.cdr.cdr.cdr.car
        else
            false_conseq = :nil
        end

        if evaluate(predicate, env)
            return [true_conseq, env]
        else
            return [false_conseq, env]
        end
    end



    self_eval = {
        :pred => lambda do |exp| 
            [Numeric, String, TrueClass, FalseClass, NilClass].map do |type|
                exp.is_a? type
            end.any?
        end,

        :eval => lambda do |exp, env|
            exp
        end
    }

    var_lookup = {
        :pred => lambda do |exp|
            exp.is_a? Symbol
        end,

        :eval => lambda do |exp, env|
            env.get(exp)
        end
    }

    quotation = {
        :pred => lambda do |exp|
            tagged_list?(exp, 'quote')
        end,
        :eval => lambda do |exp, env|
            exp.cdr.car
        end
    }

    begin_exp = {
        :pred => lambda do |exp|
            tagged_list?(exp, 'begin')
        end,
        :eval => lambda do |exp, env|
            evaluate_list(exp.cdr, env)
        end
    }

    define_or_set = {
        :pred => lambda do |exp|
            tagged_list?(exp, 'set!') or tagged_list?(exp, 'define')
        end,
        :eval => lambda do |exp, env|
            variable = exp.cdr.car
            value = evaluate(exp.cdr.cdr.car, env)

            env.set(variable, value)
        end
    }


    if_exp = {
        :pred => lambda do |exp|
            tagged_list?(exp, 'if')
        end,
        :eval => lambda do |exp, env|
            conseq_exp, conseq_env = eval_if_pred exp, env

            evaluate conseq_exp, conseq_env
        end
    }

    lambda_exp = {
        :pred => lambda do |exp|
            tagged_list?(exp, 'lambda')
        end,
        :eval => lambda do |exp, env|
            var_list = exp.cdr.car
            exps = exp.cdr.cdr
            
            Procedure.new(var_list, exps, env)
        end
    }

    call_cc = {
        :pred => lambda do |exp|
            tagged_list? exp, :'call/cc'
        end,
        :eval => lambda do |exp, env|
            procedure = evaluate(exp.cdr.car, env)


            # prepare escape procedure for current callcc
            this_escape_value = nil

            escape = NativeProcedure.new(lambda do |escape_value|
                this_escape_value = escape_value
                throw :escape, escape_value
            end)


            # apply procedure on prepared escaped procedure
            escaped = catch :escape do
                return procedure.apply(
                    Pair.new(escape, :nil)
                )
            end

            if escaped.equal? this_escape_value
                return escaped
            else
                #not for us, pass up
                throw :escape, escaped
            end
            
        end
    }

    apply_proc = {
        :pred => lambda do |exp|
            exp.is_a? Pair
        end,
        :eval => lambda do |exp, env|

            _eval_app = lambda do |exp, env|

                    result = catch :tailcall do
                        procedure_exp = exp.car
                        arg_exps = exp.cdr

                        # evaluate procedure
                        procedure = evaluate(procedure_exp, env)

                        # evaluate arguments left to right
                        arguments = values_list(arg_exps, env)

                        # apply
                        procedure.apply arguments
                    end

            end

            result = _eval_app[exp, env]

            while result.is_a? Array
                result = _eval_app[*result]
            end

            return result
        end
    }

    @evaluation_rules = [
        self_eval,
        var_lookup,
        quotation,
        begin_exp,
        define_or_set,
        if_exp,
        lambda_exp,
        call_cc,
        apply_proc,
    ]
    
    public

    def self.evaluate(expression, env)
        @evaluation_rules.each do |evaluation_rule|
            evaluation_predicate = evaluation_rule[:pred]
            evaluation_procedure = evaluation_rule[:eval]

            if evaluation_predicate[expression]
                result = evaluation_procedure[expression, env]
                return result
            end
        end

        raise "Cannot evaluate %s" % expression
    end

end
