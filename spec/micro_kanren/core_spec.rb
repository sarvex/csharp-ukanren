require 'spec_helper'

describe MicroKanren::Core do
  include MicroKanren::Core
  include MicroKanren::MiniKanrenWrappers
  include MicroKanren::Lisp

  include MicroKanren::TestPrograms
  include MicroKanren::TestSupport

  describe "#call_fresh" do
    it "second-set t1" do
      res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

      # The result should be  following the reference
      # implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L6

      #       ( ( ( #(0)    . 5 ) ) . 1  )
      exp = [ [ [ [ uvar(0) , 5 ] ] , 1  ] ]
      expected = ary_to_sexp(exp)

      lists_equal?(res, expected).must_equal true
    end

    it "second-set t2" do
      res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

      # Following reference implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L11
      cdr(res).must_be_nil
    end

    # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L13
    it "second-set t3" do
      res = car(a_and_b.call(empty_state))

      #     ( ( ( #(1)    . 5)    ( #(0)   . 7 ) )   . 2)
      exp = [ [ [ uvar(1) , 5], [ [uvar(0) , 7 ] ] ] , 2]
      sexp = ary_to_sexp(exp)

      lists_equal?(res, sexp).must_equal true
    end

    it "who cares" do
      res = take(1, call_fresh(-> (q) { fives.call(q) }).call(empty_state))

      #     ( ( ( ( #(0) . 5) ) . 1 ) )
      exp = [ [ [ [ uvar(0), 5] ] , 1 ] ]

      sexp = ary_to_sexp(exp)
      lists_equal?(res, sexp).must_equal true
    end

  end
end
