require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutBlocks < EdgeCase::Koan

  # In which the strange "yield" command allows us to consider parameters we hadn't even thought of receiving.
  # This includes receiving Ruby Blocks: a piece of code that you drop right on them.

  def method_with_block
    result = yield
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal 3, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  

  def test_blocks_can_take_arguments
    result = method_with_block_arguments do |argument|
      assert_equal argument, argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  # << is the "shovel operator." It appends stuff to a string.
  #
  # In this example, we loop through the bountiful yield of 4 items. Our block finds 4 items, and shovels them into the growing "result"

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }                            
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # ------------------------------------------------------------------

  # Amazing. The function can determine whether you gave it a block or not. 
  #
  # The true test is whether "yield" will execute a block, as presented 

  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end


  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------

  # The stuff of a PHP programmer's nightmare. Not only does the method not know what parameters are coming in,
  # we passed in parameters -- only to be like, at the last minute, 'oh hey but this variable you didn't expect has a different value'

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    assert_equal :modified_in_a_block, value
  end

  # Lambdas are standalone methods without names, like Ryan Gosling's character in "Drive."

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10)

    # Alternative calling sequence. Notice that "call" requires parenthesies. Otherwise you use brackets.
    assert_equal 11, add_one[10]
  end

  #Holy cow this is interesting. A kind of mixin in which you pass in a method.
  #The &, or "unary operator," captures the block by turning it into something called a "proc."

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal "JIM", result
  end

  # Got that? So the "yield Jim" method receives the "make everything uppercase" lambda.
  # When this is passed in, it changes the yield.

  # ------------------------------------------------------------------

  # "Hi, know of a block you'd like to pass in? Send me a proc of it"

  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one)
  end

end
