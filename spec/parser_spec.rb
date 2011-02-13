require 'spec_helper'

describe Plan::Parser do
  describe "#parse" do
    let(:parser) do
      Plan::Parser.new
    end

    def parse(code)
      parser.parse code
    end

    it "parses integers" do
      numbers = [42, 0, 1, -42, 69, 999999, -999999]

      numbers.each do |number|
        parse(number.to_s).should == number
      end
      
      parse("+69").should == 69
    end

    it "parses floats" do
      floats = ["0.0", "1.0", "-1.0", "42.5556"]

      floats.each do |float|
        parse(float).should == float.to_f
      end
    end

    it "parses strings" do
      strings = ["test", "test+-*=,.[]()", "+-*=,.[]()"]

      strings.each do |string|
        parse('"' + string + '"').should == string
      end
    end

    it "parses lists" do
      parse("(1 2 3)").car.should == 1

      parse("(1    2    3)").car.should == 1
      parse("(1 2 3    )").car.should == 1
      parse("(    1 2 3)").car.should == 1
      parse("(    1\n2\n3)").car.should == 1
      parse("(    1\n 2 \n 3  \n)").car.should == 1

      parse("(1.0 2.0 3.0)").car.should == 1.0

      parse("(1 2 3)").cdr.car.should == 2

      parse("(1 2 3)").cdr.cdr.car.should == 3

      parse("(1 2 3)").cdr.cdr.cdr.should be_nil

      parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.car.car.should == 4
      
      parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr.should be_nil

      parse("(((42)))").car.car.car.should == 42

      parse("(1 2 3 (4 5 6))").cdr.cdr.cdr.cdr.should be_nil

      parse("(1 2 3 (4 5 6 (1 (1 (1 (1))))))").cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.cdr.car.car.should == 1 
    end

    it "parses true and false" do
      parse("(#t #f)").car.should == true
      parse("(#t #f)").cdr.car.should == false
    end

    it "parses symbols" do
      parse("a").should == :a
      parse("call/cc").should == :'call/cc'

      parse("(4 symbol other 5)").car.should == 4
      parse("(symbol symbol)").car.should == :symbol
      parse("(quote abv)").cdr.car.should == :abv

      parse("/").should == :/
      parse("//").should == :"//"
      parse("%").should == :"%"

      parse("(% 22 3)").car.should == :"%"

      parse("(null? nil)").car.should == :null?
      parse("(hyphenated-stuff nil)").car.should == :'hyphenated-stuff'

      parse("(a)").car == :a

      parse("nil").should be_nil
      parse("()").should be_nil
      parse("(cons 1 nil)").cdr.cdr.car.should be_nil
      parse("(cons 1 2)").car.should == :cons
      parse("(cons 1 (cons 1 2))").cdr.cdr.car.car.should == :cons
      parse("((cons 1 2) (cons 1 2))").cdr.car.car.should == :cons

      parse("(begin (define proc1 (lambda (x) (define proc2 (lambda (y) (+ x y))) (proc2 7))) (proc1 10))").should be_kind_of(Plan::Pair)
    end

  end
end
