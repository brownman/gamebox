require File.join(File.dirname(__FILE__),'helper')
require 'behavior'

describe 'A new behavior' do
  before do
    @actor = stub
    @target = Behavior.new @actor
  end

  it 'should auto-require behaviors that it depends on' 
  it 'should relegate properly' do
    @target.should_receive(:foo).and_return(:bar)
    @target.relegates :foo

    @actor.foo.should == :bar
  end

  it 'should un-relegate properly' do
    @target.should_receive(:foo).and_return(:bar)
    @target.relegates :foo
    @actor.foo.should == :bar
    
    @target.removed

    @actor.respond_to?(:foo).should be_false
  end

end
