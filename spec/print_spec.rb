require 'spec_helper'

describe "to_scheme" do
  def run_and_render(code, env=nil)
    Plan.run(code, env).to_scheme
  end

  def parse_and_render code
    Plan::Parser.new.parse(code).to_scheme
  end
  
  context "atoms" do
    it "renders atoms" do
      run_and_render("1").should == '1'
      run_and_render("-42").should == '-42'
      run_and_render('"str"').should == '"str"'
      parse_and_render('str').should == 'str'
      parse_and_render('#t').should == '#t'
      run_and_render('#t').should == '#t'
      parse_and_render('#f').should == '#f'
      run_and_render('#f').should == '#f'
      parse_and_render('nil').should == 'nil'
      run_and_render('nil').should == 'nil'
    end
  end

  context "linked lists" do
    it "renders lists" do
      lists = [
        '(1 2 3)',
        '(1 2     3)',
        '(1 2 3 (4     5    6))',
        '(1)',
        '(+ 1 2)',
        '(null? 5)',
        '(1 2 3)'
      ]
      
      lists.each do |list|
        parse_and_render(list).should == list.gsub(/\s+/, ' ')
      end

      run_and_render("(cons 1 (cons 2 (cons 3 nil)))").should == "(1 2 3)"
    end

    it "renders pairs" do
      run_and_render("(cons 1 2)").should == "(1 . 2)"
      run_and_render('(cons (+ 33 66) "str")').should == '(99 . "str")'
    end
  end

  context "procs" do
    it "renders procs" do
      run_and_render("(lambda (x) x)").should == "(lambda (x) x)"
    end
  end
end
