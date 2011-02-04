require 'spec_helper'

describe Scheme do
  describe "#parse" do

    it "parses numbers" do
      numbers = [42, 0, 1, -42, 69, 999999, -999999]

      numbers.each do |number|
        Scheme.parse(number.to_s).should == number
      end
      
      Scheme::parse("+69").should == 69
    end

    it "parses strings" do
      strings = ["test", "test+-*=,.[]()", "+-*=,.[]()"]

      strings.each do |string|
        Scheme.parse('"' + string + '"').should == string
      end
    end

    it "parses lists" do
      Scheme.parse("(1 2 3)").car.should == 1

      Scheme.parse("(1 2 3)").cdr.car.should == 2

      Scheme.parse("(1 2 3)").cdr.cdr.car.should == 3

      Scheme.parse("(1 2 3)").cdr.cdr.cdr.should be_nil

      Scheme.parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.car.car.should == 4
      
      Scheme.parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr.should be_nil

      Scheme.parse("(((42)))").car.car.car.should == 42

      Scheme.parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr.should be_nil

      Scheme.parse("(1 2 3 (4 5 6 (1 (1 (1 (1))))))").cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.cdr.car.car.should == 1 
    end

    it "parses true and false" do
      Scheme.parse("(#t #f)").car.should == true
      Scheme.parse("(#t #f)").cdr.car.should == false
    end

    it "parses symbols" do
      Scheme.parse("a").should == :a
      Scheme.parse("call/cc").should == :'call/cc'

      Scheme.parse("(4 symbol other 5)").car.should == 4
      Scheme.parse("(symbol symbol)").car.should == :symbol
      Scheme.parse("(quote abv)").cdr.car.should == :abv

      Scheme.parse("(null? nil)").car.should == :null?
      Scheme.parse("(hyphenated-stuff nil)").car.should == :'hyphenated-stuff'

      #assert_equal(:a, Scheme::parse('(a)').car)
      Scheme.parse("(a)").car == :a

      Scheme.parse("nil").should be_nil
      Scheme.parse("()").should be_nil
      Scheme.parse("(cons 1 nil)").cdr.cdr.car.should be_nil
      Scheme.parse("(cons 1 2)").car.should == :cons
      Scheme.parse("(cons 1 (cons 1 2))").cdr.cdr.car.car.should == :cons
      Scheme.parse("((cons 1 2) (cons 1 2))").cdr.car.car.should == :cons

      Scheme.parse("(begin (define proc1 (lambda (x) (define proc2 (lambda (y) (+ x y))) (proc2 7))) (proc1 10))").should be_kind_of(Scheme::Pair)
    end

  end
end
