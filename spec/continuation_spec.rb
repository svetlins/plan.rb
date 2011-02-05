require 'spec_helper'

describe Scheme do
  describe "#run" do
    def run(code)
      Scheme.run(code)
    end

    context "continuation" do
      it "provides call/cc primitive" do
        run("(call/cc
               (lambda (throw)
                 (+ 5 
                    (* 10 
                       (call/cc
                         (lambda (esc)
                           (* 100
                              (esc 3))))))))").should == 35
        run("(call/cc
               (lambda (throw)
                 (+ 5 
                    (* 10 
                       (call/cc
                         (lambda (esc)
                           (* 100
                              (throw 3))))))))").should == 3
      end
    end
  end
end
