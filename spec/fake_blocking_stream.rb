class FakeBlockingStream

  def initialize
      @queue = Queue.new
  end

  # @param [String] string
  def write(string)
    string.each_char {|char|
      @queue.enq(char)
    }
  end

  # @return [String] Char
  def getc
    @queue.deq
  end

  alias << write
end