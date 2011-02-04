require 'spec_helper'

describe Scheme::Pair do
  context "used as linked list" do
    let(:linked_list) do
      Scheme::make_linked_list([1,2,3,4])
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

describe Scheme do
  context "linked list class methods" do
    describe "#make_linked_list" do
      it "makes linked list out of arrays" do
        linked_list = Scheme.make_linked_list([1,2,3,4])
        
        linked_list.car.should == 1
        linked_list.cdr.cdr.cdr.car.should == 4
        linked_list.cdr.cdr.cdr.cdr.should be_nil
      end

    end

    describe "#make_array" do
      it "makes arrays out of linked lists" do
        flat_array = Scheme::make_array(
            Scheme::Pair.new(1,
                Scheme::Pair.new(2,
                    Scheme::Pair.new(3, nil)
                )
            )
        )

        flat_array.should == [1,2,3]

        nested_array = Scheme.make_array(
            Scheme::Pair.new(1,
                Scheme::Pair.new(Scheme::Pair.new(42, Scheme::Pair.new(69, nil)),
                    Scheme::Pair.new(3, nil)
                )
            )
        )
        nested_array.should == [1, Scheme::Pair.new(42, Scheme::Pair.new(69, nil)), 3]

        Scheme.make_array(Scheme::Pair.new(1,nil)).should == [1]

        Scheme.make_array(
            Scheme::Pair.new(Scheme::Pair.new(1,2), nil)
        ).should == [Scheme::Pair.new(1,2)]
      end
    end

    describe "together" do
      def dont_change_array(array)
        Scheme.make_array(Scheme.make_linked_list(array)).should == array
      end
      def dont_change_linked_list(list)
        Scheme.make_linked_list(Scheme.make_array(list)).should == list
      end

      it "don't change an array" do
        dont_change_array [1,2,3]
        dont_change_array []
        dont_change_array [1]
        dont_change_array [Scheme::Pair.new(1,2), Scheme::Pair.new(42,69)]
      end

      it "don't change a linked list" do
        dont_change_linked_list(
            Scheme::Pair.new(1,Scheme::Pair.new(2,Scheme::Pair.new(3, nil)))
        )
        dont_change_linked_list(
            Scheme::Pair.new(1,nil)
        )
      end
    end

  end
end
