require 'spec_helper'

describe Plan::Exp do
  def make_exp(code)
    if code.is_a? String
      ast = Plan::Parser.new.parse code
    else
      code = ast
    end

    Plan::Exp.new ast
  end

  describe "#tagged_list?" do
    it "tells if the exp is a list starting with the given symbol" do
      make_exp('(if #t 42)').tagged_list?('if').should == true

      make_exp('(lambda (x) (* x x))').tagged_list?(:not_lambda).should == false
      make_exp('42').tagged_list?(42).should == false
      make_exp('stuff').tagged_list?("stuff").should == false
    end

    it "should work with both strings and symbols" do
      make_exp('(lambda (x) (* x x))').tagged_list?('lambda').should == true
      make_exp('(lambda (x) (* x x))').tagged_list?(:lambda).should == true
    end
  end

  describe "#head" do
    it "gets the head of a list" do
      make_exp("(1 2 3)").head.body.should == 1
      make_exp("(lambda (x) (* x x))").head.body.should == :lambda
    end

    it "fails when applied to something different than a list" do
      lambda { make_exp("stuff").head }.should raise_error(NoMethodError)
    end
  end

  describe "#tail" do
    it "gets the tail of list" do
      make_exp("(1 2 3)").tail.body.should == make_exp("(2 3)").body
    end

    it "fails when applied to something different than a list" do
      lambda { make_exp("stuff").tail }.should raise_error(NoMethodError)
    end
  end


  describe "selectors" do
    let(:if_exp) do
      make_exp("(if (= n 1) 1 (* n (fact (- n 1))))")
    end
    let(:if_exp_no_else) do
      make_exp("(if (sexy? x) (flirt x))")
    end

    describe "if_pred" do
      it "gets the predicate part of an if expression" do
        if_exp.if_pred.should == make_exp("(= n 1)")
      end
    end

    describe "if_then" do
      it "gets the then part of an if expression" do
        if_exp.if_then.should == make_exp("1")
      end
    end

    describe "if_else" do
      it "gets the else part of an if expression if there is one" do
        if_exp.if_else.should == make_exp("(* n (fact (- n 1)))")
        if_exp.if_else.should_not == make_exp("(* x (fact (- x 1)))")

        if_exp_no_else.if_else.should == Plan::Exp.new(nil)
      end
    end
  end
end
