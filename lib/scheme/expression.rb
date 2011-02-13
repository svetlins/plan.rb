module Scheme
  class Exp
    #TODO: remove
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def evaluate(env)
      Scheme.evaluation_rules.each do |evaluation_rule|
        evaluation_predicate = evaluation_rule[:pred]
        evaluation_procedure = evaluation_rule[:eval]

        if evaluation_predicate.call(@body)
          return evaluation_procedure.call(@body, env)
        end
      end

      raise "Cannot evaluate #{expression}"
    end

    def tagged_list?(tag)
      @body.is_a? Pair and @body.car == tag.to_sym
    end

    def evaluate_list(env)
      if @body.cdr
        head.evaluate(env)
        tail.evaluate_list(env)
      else
        head.evaluate(env)
      end
    end

    def evaluate_begin(env)
      tail.evaluate_list(env)
    end

    def procedure_call?
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
      @body.is_a? Pair and not not_relevant.include? @body.car
    end

    def evaluate_proc_body(env)
      if @body.cdr
        head.evaluate(env)
        tail.evaluate_proc_body(env)
      else
        # this is the last expression
        # it is in else because it's value is the value
        # of the procedure, and because it should be 
        # analyzed for tail call
        last_exp = @body.car

        # analyze for tail call
        if last_exp.is_a? Pair
          if Exp.new(last_exp).procedure_call?
            throw :tailcall, [last_exp, env]
          elsif last_exp.car == :if
            conseq_exp, conseq_env = Exp.new(last_exp).eval_if_pred(env)

            if Exp.new(conseq_exp).procedure_call?
              throw :tailcall, [conseq_exp, conseq_env]
            end
          end
        end

        # not tail call, evaluate normally
        return Exp.new(last_exp).evaluate(env)
      end
    end

    def values_list(env)
      if @body
        Pair.new(head.evaluate(env), tail.values_list(env))
      end
    end

    def eval_if_pred(env)
      predicate = @body.cdr.car
      true_conseq = @body.cdr.cdr.car

      if @body.cdr.cdr.cdr
        false_conseq = @body.cdr.cdr.cdr.car
      else
        false_conseq = nil
      end

      if Exp.new(predicate).evaluate(env)
        return [true_conseq, env]
      else
        return [false_conseq, env]
      end
    end

    def head
      Exp.new(@body.car)
    end

    def tail
      Exp.new(@body.cdr)
    end
  end
end

module Scheme

  @apply_proc = {
    :pred => lambda do |exp|
      exp.is_a? Pair
    end,

    :eval => lambda do |exp, env|

      _eval_app = lambda do |exp, env|

        result = catch :tailcall do
          procedure_exp = exp.car
          arg_exps = exp.cdr

          # evaluate procedure
          procedure = Exp.new(procedure_exp).evaluate(env)

          # evaluate arguments left to right
          arguments = Exp.new(arg_exps).values_list(env)

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

  @self_eval = {
    :pred => lambda do |exp| 
      [Numeric, String, TrueClass, FalseClass, NilClass].map do |type|
        exp.is_a? type
      end.any?
    end,

    :eval => lambda do |exp, env|
      exp
    end
  }

  @var_lookup = {
    :pred => lambda do |exp|
      exp.is_a? Symbol
    end,

    :eval => lambda do |exp, env|
      env.get(exp)
    end
  }

  @quotation = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'quote'
    end,
    :eval => lambda do |exp, env|
      exp.cdr.car
    end
  }

  @begin_exp = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'begin'
    end,
    :eval => lambda do |exp, env|
      Exp.new(exp).evaluate_begin env
    end
  }

  @define_or_set = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'set!' or Exp.new(exp).tagged_list? 'define'
    end,
    :eval => lambda do |exp, env|
      variable = exp.cdr.car

      value = Exp.new(exp.cdr.cdr.car).evaluate(env)

      env.set(variable, value)
    end
  }


  @if_exp = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'if'
    end,
    :eval => lambda do |exp, env|
      conseq_exp, conseq_env = Exp.new(exp).eval_if_pred env

      Exp.new(conseq_exp).evaluate conseq_env
    end
  }

  @lambda_exp = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'lambda'
    end,
    :eval => lambda do |exp, env|
      var_list = exp.cdr.car
      exps = exp.cdr.cdr

      Procedure.new(var_list, exps, env)
    end
  }

  @call_cc = {
    :pred => lambda do |exp|
      Exp.new(exp).tagged_list? 'call/cc'
    end,
    :eval => lambda do |exp, env|
      procedure = Exp.new(exp.cdr.car).evaluate(env)


      # prepare escape procedure for current callcc
      this_escape_value = nil

      escape = NativeProcedure.new(lambda do |escape_value|
        this_escape_value = escape_value
        throw :escape, {:origin => :escape_value, :value => escape_value}
      end)


      # apply procedure on prepared escaped procedure
      result = catch :escape do
        result = procedure.apply(
          Pair.new(escape, :nil)
        )

        {:origin => :return_value, :value => result}
      end

      case result[:origin]
      when :escape_value
        if result[:value].equal? this_escape_value
          return result[:value]
        else
          #not for us, pass up
          throw :escape, result
        end
      when :return_value
        return result[:value]
      end

    end
  }

  def self.evaluation_rules
    [
      @self_eval,
      @var_lookup,
      @quotation,
      @begin_exp,
      @define_or_set,
      @if_exp,
      @lambda_exp,
      @call_cc,
      @apply_proc,
    ]
  end

end
