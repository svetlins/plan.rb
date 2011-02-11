require 'spec_helper'

describe Scheme::Exp do
  def make_exp(code)
    ast = Scheme::Parser.new.parse code
    Scheme::Exp.new ast
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
  end

end
