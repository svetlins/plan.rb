require 'spec_helper'

describe Plan do
  describe "#run" do
    def run(code, env = nil)
      Plan.run code, env
    end
    context "self evaluating" do
      it "evaluates numbers" do
        run("1").should == 1
      end

      it "evaluates strings" do
        run("\"svetlin\"").should == "svetlin"
      end

      it "evaluates booleans" do
        run("#t").should == true
        run("#f").should == false
      end

      it "evaluates nil" do
        run("nil").should == nil
        run("()").should == nil
      end
    end

    context "variable lookup" do
      it "evaluates a variable from set up environment" do
        test_env = {:var => 42}

        run("var", test_env).should == 42
      end

    end

    context "schemish quote" do
      it "evaluates quoted symbols to ruby symbols" do
        run("(quote a)").should == :a
      end

      it "evaluates quoted lists" do
        run("(quote (1 2 3))").car.should == 1
        run("(quote (1 2 3))").cdr.cdr.car.should == 3
      end
    end

    context "schemish begin" do
      it "evaluates expressions in a begin to the the last expression" do
        run("(begin 1 2 3)").should == 3
        run("(begin var)", {:var => 42}).should == 42
      end
    end

    context "schemish set" do
      it "evaluates set by creating or overriding a binding" do
        run("(begin (set! a 69) a)").should == 69
        run("(begin (set! a 69) a)", {:a => 42}).should == 69
        run("(begin (set! a 69) (set! a 112) a)", {:a => 42}).should == 112
      end
    end

    context "define" do
      it "evaluates a define by creating or overriding a binding" do
        run("(begin (define a 69) a)").should == 69
        run("(begin (define a 69) a)", {:a => 42}).should == 69
        run("(begin (define a 69) (define a 112) a)", {:a => 42}).should == 112
      end
    end

    context "if" do
      it "evaluates if to value of then clause when condition's true" do
        run('(if #t "baba" "dyado")').should == 'baba'
      end
      it "evaluates if to value of else clause when condition's false" do
        run('(if #f "baba" "dyado")').should == 'dyado'
      end

      it "evaluates to nil on no else clause and false condition" do
        run('(if #f "baba i dyado")').should be_nil
      end
    end

    context "lambda" do
      it "evaluates lambda to a callable proc object" do
        run("((lambda (x) x) 42)").should == 42

        run("(begin
               (define myproc
                 (lambda (x)
                   x))
               (myproc 1337))").should == 1337

        run("(begin
               (define myproc
                 (lambda ()
                   666))
               (myproc))").should == 666
      end
    end

    context "operations" do
      it "evaluates calls to arithmetic operations" do
        run("(+ 1 2)").should == 3
        run("(+ 1 (+ 1 1))").should == 3
        run("(- 42 1)").should == 41
        run("(- -42 1)").should == -43
        run("(* 2 (* 2 2))").should == 8

        run("(+ 1 0.0)").should == 1.0
        run("(* 1 0.0)").should == 0.0
        run("(- -42 2.5)").should == -44.5

        run("(/ 2 4)").should == 0.5
        run("(/ 3 9)").should == 1 / 3.0
        run("(// 7 3)").should == 7 / 3
        run("(% 7 3)").should == 7 % 3
      end

      it "evaluates calls to compare operations" do
        run("(= 1 1)").should == true
        run("(= #t (= 1 1))").should == true
        run("(= 1 2)").should == false
      end

      it "evaluates factorial" do
        run("(begin
               (define fact
                 (lambda (n)
                   (if (= n 1)
                     1
                     (* n (fact (- n 1))))))
               (fact 10))").should == 3628800
      end
    end

    context "pairs" do
      it "evaluates a cons to a pair" do
        run("(cons 1 2)").car.should == 1
        run("(cons 1 2)").cdr.should == 2
        run("(cons 1 nil)").cdr.should be_nil

        run("(cons 1 (cons 2 nil))").car.should == 1
        run("(cons 1 (cons 2 nil))").cdr.car.should == 2
        run("(cons 1 (cons 2 nil))").cdr.cdr.should be_nil
      end

      it "evaluates a car and cdr to the first and second in pair" do
        run("(car (cons 1 2))").should == 1
        run("(cdr (cons 1 2))").should == 2
        run("(car
               (cdr 
                 (cdr 
                   (cons
                     1
                     (cons 
                       2
                       (cons 
                         3
                         nil))))))").should == 3
      end
    end

    context "in general" do
      it "evaluates pieces of code" do
        run("(begin
               (define proc 
                       (lambda (x)
                         (+ x 11)))
               (proc 30))").should == 41

        run("(begin
               (define proc1
                       (lambda (x) 
                         (define proc2 
                                 (lambda (y) (+ x y))) 
                         (proc2 7))) 
               (proc1 10))").should == 17
      end
    end
  end
end
