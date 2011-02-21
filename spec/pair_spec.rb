require 'spec_helper'

describe Plan::Pair do
  def parse(code)
    Plan::Parser.new.parse(code)
  end

  describe "==" do
    it "returns true for identical expressions" do
      ["(if (= n 1) 1)", "(1 2 3)", "1", "sym"].each do |exp|
        parse(exp).should == parse(exp)
      end
    end

    it "returns false for different expressions" do
      parse('(1 2 3)').should_not == parse('(1 1 1)')
    end
  end

  context "used as linked list" do
    let(:linked_list) do
      Plan::make_linked_list([1,2,3,4])
    end

    describe "#map" do
      it "maps values" do
        squares = linked_list.map { |e| e ** 2 }

        squares.car.should == 1
        squares.cdr.cdr.cdr.car.should == 16
      end
    end

    describe "#zip" do
      it "zips two linked lists" do
        squares = linked_list.map { |e| e ** 2 }
        cubes = linked_list.map { |e| e ** 3 }

        zipped = squares.zip(cubes)

        zipped[0].should == [1,1]
        zipped[1].should == [4,8]
        zipped[2].should == [9, 27]
      end
    end
  end
end

describe Plan do
  context "linked list class methods" do
    describe "#make_linked_list" do
      it "makes linked list out of arrays" do
        linked_list = Plan.make_linked_list([1,2,3,4])
        
        linked_list.car.should == 1
        linked_list.cdr.cdr.cdr.car.should == 4
        linked_list.cdr.cdr.cdr.cdr.should be_nil
      end

    end

    describe "#make_array" do
      it "makes arrays out of linked lists" do
        flat_array = Plan::make_array(
            Plan::Pair.new(1,
                Plan::Pair.new(2,
                    Plan::Pair.new(3, nil)
                )
            )
        )

        flat_array.should == [1,2,3]

        nested_array = Plan.make_array(
            Plan::Pair.new(1,
                Plan::Pair.new(Plan::Pair.new(42, Plan::Pair.new(69, nil)),
                    Plan::Pair.new(3, nil)
                )
            )
        )
        nested_array.should == [1, Plan::Pair.new(42, Plan::Pair.new(69, nil)), 3]

        Plan.make_array(Plan::Pair.new(1,nil)).should == [1]

        Plan.make_array(
            Plan::Pair.new(Plan::Pair.new(1,2), nil)
        ).should == [Plan::Pair.new(1,2)]
      end
    end

    describe "together" do
      def dont_change_array(array)
        Plan.make_array(Plan.make_linked_list(array)).should == array
      end
      def dont_change_linked_list(list)
        Plan.make_linked_list(Plan.make_array(list)).should == list
      end

      it "don't change an array" do
        dont_change_array [1,2,3]
        dont_change_array []
        dont_change_array [1]
        dont_change_array [Plan::Pair.new(1,2), Plan::Pair.new(42,69)]
      end

      it "don't change a linked list" do
        dont_change_linked_list(
            Plan::Pair.new(1,Plan::Pair.new(2,Plan::Pair.new(3, nil)))
        )
        dont_change_linked_list(
            Plan::Pair.new(1,nil)
        )
      end
    end

  end
end
