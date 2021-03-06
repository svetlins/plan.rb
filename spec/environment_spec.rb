require 'spec_helper'

describe Plan::Environment do
  context "in general" do
    before(:each) do
      @env = Plan::Environment.new
    end
    it "creates and reads bindings with get and set" do
      @env.set('a', 2)
      @env.get('a').should == 2
    end

    it "makes bindings overridable" do
      @env.set('a', 2)
      @env.set('a', 999)

      @env.get('a').should == 999
    end

    it "raises on unexistent binding" do
      var_name = 'the-truth-about-world'
      lambda do
        @env.get(var_name)
      end.should raise_error(NameError, "Unexistent binding: #{var_name}")
    end

    it "can be extended" do
      @env.set('a', 1)
      inner_frame = @env.extend({'stuff' => 42})

      inner_frame.get('a').should == 1
      inner_frame.get('stuff').should == 42

      inner_frame.set('a', 2)

      inner_frame.get('a').should == 2
      @env.get('a').should == 1

      lambda do
        @env.get('stuff')#.should_not == 42
      end.should raise_error
    end

  end
end
