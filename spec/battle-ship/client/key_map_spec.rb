# coding: utf-8

require "battle-ship/client/key_map"

include BattleShip::Client

describe BattleShip::Client::KeyMap do

  before(:all) do
    Thread.abort_on_exception = true
    @stream = FakeBlockingStream.new

    @key_map = KeyMap.new(@stream)
  end

  after(:all) do

  end

  it "Array of Bindings's mustn't be empty after running" do
    lambda { @key_map.start }.should raise_error
  end

  it "Listening must be done in separated thread" do
    @key_map.bind "\r", -> { KeyMap::STOP }

    @key_map.start
    wait_thread
    @key_map.listener.should be_an_instance_of(Thread)
    @key_map.run?.should be_true

    @key_map.stop
    wait_thread
    @key_map.run?.should be_false
  end

 it "Must stop after calling corresponding command" do
    @key_map.bind "x", -> { KeyMap::STOP }
    @stream << 'x'
    @key_map.start

    wait_thread

    @key_map.run?.should be_false
  end

  it "To be called passed proc" do

    checker = Struct.new(:called).new(false)
    proc = ->(x){ ->{x.called = true }}[checker]

    @key_map.bind 'c', proc
    @key_map.start

    checker.called.should be_false

    @stream.write 'c'
    wait_thread

    checker.called.should be_true
  end

  private
  def wait_thread
    sleep 0.05
  end


end