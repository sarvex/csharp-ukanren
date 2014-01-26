module MicroKanren
  module MiniKanrenWrappers
    include Lisp

    # Advances a stream until it matures. Per microKanren document 5.2, "From
    # Streams to Lists."
    def pull(stream)
      !cons_cell?(stream) && stream.is_a?(Proc) ? pull(stream.call) : stream
    end

    def take(n, stream)
      if n > 0
        cur = pull(stream)
        cons(car(cur), take(n - 1, cdr(cur))) if cur
      end
    end

  end
end
