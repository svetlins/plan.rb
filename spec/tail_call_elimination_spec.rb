require 'spec_helper'

describe Scheme do
  describe "#run" do
    context "tail call elimination" do
      def run(code)
        Scheme.run code
      end

      it "makes possible arbitrary deep call stacks for tail calling procs" do
        run("(begin
               (define 
                 proc 
                 (lambda (x) 
                   (if (= x 2000)
                     x 
                     (proc  (+ x 1)))))
               (proc 1))").should == 2000

        run("(begin
               (define 
                 proc 
                 (lambda (x) 
                   (if (= x 2000)
                     42 
                     (proc  (+ x 1)))))
               (proc 1))").should == 42
      end

      it "fails on deepish call stacks otherwise" do
        lambda do 
          run("(begin
                 (define 
                   proc 
                   (lambda (x) 
                     (if (= x 2000)
                       42 
                       (+ 1 (proc (+ x 1))))))
                 (proc 2))")
        end.should raise_error(SystemStackError)
        #end.call
      end
    end
  end
end
