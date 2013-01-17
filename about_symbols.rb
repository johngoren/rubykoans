require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutSymbols < EdgeCase::Koan

  # So here's a symbol. Is it a Symbol? Yes. Yes, sir, I do believe it is.
 
  def test_symbols_are_symbols
    symbol = :ruby
    assert_equal true, symbol.is_a?(Symbol)
  end


  def test_symbols_can_be_compared
    symbol1 = :a_symbol
    symbol2 = :a_symbol
    symbol3 = :something_else

    assert_equal true, symbol1 == symbol2
    assert_equal false, symbol1 == symbol3

    # "Just because you're accepted doesn't mean you belong."
    # -- tagline from "School Ties" (1992)

  end

  def test_identical_symbols_are_a_single_internal_object
    symbol1 = :a_symbol
    symbol2 = :a_symbol

    assert_equal true, symbol1           == symbol2
    assert_equal true, symbol1.object_id == symbol2.object_id

    # This may seem like the trippiest concept in all of Ruby, but it's simple:
    #
    # A symbol is like a single star in the firmament. Only one of each kind exists, even though many variables may point to it.
    #
    # The grand table of all symbols can be reached by visiting our friend Symbol.all_symbols

  end

  def test_method_names_become_symbols

    # This here .map enumerator allows us to make a Ruby Block allowing us to run through that grand table of symbols.

    symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }
    assert_equal true, symbols_as_strings.include?("test_method_names_become_symbols")
  end

  # THINK ABOUT IT:
  #
  # Q: Why do we convert the list of symbols to strings and then compare
  # against the string value rather than against symbols?

  # A: Because of something like the Observer Effect. By talking about that symbol, you create it.
  # "If we start talking about it we'll be here all day, making diagrams with straws!" -- Bruce Willis in "Looper"

  in_ruby_version("mri") do
    RubyConstant = "What is the sound of one hand clapping?"
    def test_constants_become_symbols
      all_symbols = Symbol.all_symbols

      assert_equal false, all_symbols.include?(__)
    end
  end

  # So it turns out a symbol is equal to itself as a string.

  def test_symbols_can_be_made_from_strings
    string = "catsAndDogs"
    assert_equal :"catsAndDogs", string.to_sym
  end

  # Unlike filenames from MS-DOS...

  def test_symbols_with_spaces_can_be_built
    symbol = :"cats and dogs"

    assert_equal symbol, symbol.to_sym
  end

  def test_symbols_with_interpolation_can_be_built
    value = "and"
    symbol = :"cats #{value} dogs"

    assert_equal symbol, :"cats and dogs".to_sym
  end

  # "That symbol stuff will mess with your mind, man!"
  # -- with apologies to the Total Recall remake
  #
  # Q: In the above, why the weird, symbol-like :"cats and dogs" syntax...before becoming a symbol? What can it all mean?
  # A: This is a special method for creating symbols whose names contain spaces.
  # i.e. :'Benedict Cumberbatch'


  # You interpolate a symbol, you turn it into a string

  def test_to_s_is_called_on_interpolated_symbols
    symbol = :cats
    string = "It is raining #{symbol} and dogs."

    assert_equal "It is raining cats and dogs.", string
  end

  # You shouldn't compare a symbol to a string

  def test_symbols_are_not_strings
    symbol = :ruby
    assert_equal false, symbol.is_a?(String)
    assert_equal false, symbol.eql?("ruby")
  end

  # In this exercise we send messages to the symbol, then watch as they are rejected.

  def test_symbols_do_not_have_string_methods
    symbol = :not_a_string
    assert_equal false, symbol.respond_to?(:each_char)
    assert_equal false, symbol.respond_to?(:reverse)
  end

  # It's important to realize that symbols are not "immutable
  # strings," though they are immutable. None of the
  # interesting string operations are available on symbols.
  #
  # So don't try to stick them together like a couple of low-rent HTML strings in your Javascript from 1998.

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further down the path
    assert_raise(NoMethodError) do
      :cats + :dogs
    end
  end

  def test_symbols_can_be_dynamically_created
    assert_equal :"catsdogs", ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Q: Why is it not a good idea to dynamically create a lot of symbols?
  #
  # A: Conservation of memory. When you reserve RAM for a symbol, you don't get it back until the program ends.
  # That's how immutable a symbol is.
  
end
