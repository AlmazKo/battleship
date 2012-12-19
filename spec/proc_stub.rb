class ProcStub < Proc

  attr_reader :received

  def initialize
    @called = false
    @received = nil
    super()
  end

  def call(*args)
    @received, *_ = args
    @called = true
    super()
  end

  def called?
    @called
  end
end