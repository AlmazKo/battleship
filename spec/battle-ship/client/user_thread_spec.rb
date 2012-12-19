# coding: utf-8

require "battle-ship/client/user_thread"

include BattleShip::Client

describe BattleShip::Client::UserThread do

  before(:all) do
    Thread.abort_on_exception = true
  end

  before(:each) do
    @input_stream = FakeBlockingStream.new
    @user_thread = UserThread.new(@input_stream)
    wait_thread
  end

  after(:each) do
    @user_thread.stop
    wait_thread
  end

  it 'После запуска должен оставаться работающим потоком' do
    @user_thread.alive?.should be_true
    @user_thread.status.should_not eq 'aborting'
  end

  it 'Должен считывать входной поток' do
    @input_stream.queue.should have(0).chars

    @input_stream.write('t')
    wait_thread
    @input_stream.queue.should have(0).chars
  end

  it 'После выключения должен остановится' do
    @user_thread.stop
    @user_thread.status.should eq 'aborting'

    wait_thread
    @user_thread.alive?.should be_false
  end

  it "on_key_press должен вызывать соответствующих обработчиков" do
    proc = ProcStub.new {}
    @user_thread.on_key_press('x', proc)

    wait_thread

    proc.called?.should be_false

    @input_stream.write('x')
    wait_thread
    proc.called?.should be_true
  end

  it "on_key_press должен вызывать только подключенных обработчиков" do
    proc = ProcStub.new {}
    @user_thread.on_key_press('x', proc)

    @input_stream.write('y')
    wait_thread

    proc.called?.should be_false

    @input_stream.write('x')
    wait_thread

    proc.called?.should be_true
  end

  it "on_key_press должен поддерживать управляющие конструкции" do
    proc = ProcStub.new {}
    @user_thread.on_key_press(UserThread::DOWN, proc)

    @input_stream.write(UserThread::DOWN)
    wait_thread

    proc.called?.should be_true
  end

  it "on_submit должен принимать только по enter" do
    proc = ProcStub.new {}
    @user_thread.on_submit(proc)

    @input_stream.write('foo')
    @input_stream.write(UserThread::ENTER)
    wait_thread

    proc.called?.should be_true
    proc.received.should eq 'foo'
  end

  private

  def wait_thread
    sleep 0.05
  end
end