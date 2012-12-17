# coding: utf-8
$:.unshift(File.dirname(__FILE__))

require "helper"
require "/home/almazko/projects/battleship/lib/battle-ship/Client/key_map"

include BattleShip::Client

describe BattleShip::Client::KeyMap do

  before(:all) do
    Thread.abort_on_exception = true
    @stream = File.open('fake_stream', 'w'){}
    @stream = File.open('fake_stream', 'a+')
    @key_map = BattleShip::Client::KeyMap.new(@stream)
  end

  after(:all) do
    @stream.close
  end

  it 'Массив bindings должен содержать как минимум одну операцию выхода' do
    lambda { @key_map.start }.should raise_error
  end

  it 'Считывание должно проводится в отдельном потоке' do
    @key_map.bind "\r", -> { KeyMap::STOP }

    @key_map.start
    thread_wait
    @key_map.listener.should be_an_instance_of(Thread)
    @key_map.run?.should be_true

    @key_map.stop
    thread_wait
    @key_map.run?.should be_false
  end

  it 'Работа должна прекратиться при получении соответствующей команды' do
    @key_map.bind "x", -> { KeyMap::STOP }
    @stream << 'x'
    @key_map.start

    @key_map.run?.should be_false
  end

  it 'Должен вызваться переданный proc, если сработал binding' do

    checker = Struct.new(:called).new(false)
    proc = ->(x){ ->{x.called = true }}[checker]

    @key_map.bind 'c', proc
    @key_map.start

    checker.called.should be_false

    @stream.write 'c'
    thread_wait

    checker.called.should be_true
  end


  private
  def thread_wait
    sleep 0.05
  end


end