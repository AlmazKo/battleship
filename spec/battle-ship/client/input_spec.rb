# coding: utf-8

require "battle-ship/client/input"

include BattleShip::Client

describe BattleShip::Client::Input do

  before(:all) do
    Thread.abort_on_exception = true
  end

  before(:each) do
    @stream = FakeBlockingStream.new
    @input = Input.new(@stream)
    wait_thread
  end

  after(:each) do
    @input.stop
    wait_thread
  end

  it 'После запуска должен оставаться работающим потоком' do
    @input.alive?.should be_true
    @input.status.should_not eq 'aborting'
  end

  it 'Должен считывать входной поток' do
    @stream.queue.should have(0).chars

    @stream.write('t')
    wait_thread
    @stream.queue.should have(0).chars
  end

  it 'После выключения должен остановится' do
    @input.stop
    @input.status.should eq 'aborting'

    wait_thread
    @input.alive?.should be_false
  end

  it "on_key_press должен вызывать соответствующих обработчиков" do
    proc = ProcStub.new {}
    @input.on_key_press('x', proc)

    wait_thread

    proc.called?.should be_false

    @stream.write('x')
    wait_thread
    proc.called?.should be_true
  end

  it "on_key_press должен вызывать только подключенных обработчиков" do
    proc = ProcStub.new {}
    @input.on_key_press('x', proc)

    @stream.write('y')
    wait_thread

    proc.called?.should be_false

    @stream.write('x')
    wait_thread

    proc.called?.should be_true
  end

  it "on_key_press должен поддерживать управляющие конструкции" do
    proc = ProcStub.new {}
    @input.on_key_press(Input::DOWN, proc)

    @stream.write(Input::DOWN)
    wait_thread

    proc.called?.should be_true
  end

  it "on_submit должен принимать только по enter" do
    proc = ProcStub.new {}
    @input.on_submit(proc)

    @stream.write('foo')
    @stream.write(Input::ENTER)
    wait_thread

    proc.called?.should be_true
    proc.received.should eq 'foo'
  end

  private

  def wait_thread
    sleep 0.05
  end
end