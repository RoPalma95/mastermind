class Mastermind
  attr_reader :maker, :breaker, :game_mode

  WELCOME_MESSAGE = "\n\t\t\tWELCOME TO MASTERMIND\n\n  If you play as the Codemaker, you have to pick four colors from the following options:\n
  \t[R]ed, [G]reen, [Y]ellow, [O]range, [B]lack, [W]hite\n
  Use only the color's initial to input your code, or your guesses if you are playing as the codebreaker. The codebreaker has 12 turns
  to figure out the secret code.\n
  Would you like to be the Codemaker[M] or the Codebreaker[B]? >> "
  CODE_OPTIONS = %w[R G Y O B W]

  def initialize
    print WELCOME_MESSAGE
    @game_mode = gets.chomp.upcase
    @maker = Codemaker.new(game_mode)
    @breaker = Codebreaker.new(maker.code)
    puts out_of_tries(breaker.tries)
  end

  def out_of_tries(tries)
    "\n  You ran out of tries. The secret code was #{maker.code}" if tries == 12
  end
end

class Codemaker < Mastermind
  attr_reader :code

  def initialize(game_mode)
    if game_mode == 'B'
      @code = CODE_OPTIONS.sample(4)
    else
      input_code
    end
  end

  def input_code
    print "\n  Enter your secret code (use 4 different colors)>> "
    @code = gets.chomp.upcase.split('')
  end

end

class Codebreaker
  private

  attr_accessor :correct_color, :correct_pos
  attr_reader :guess, :secret_code
  attr_writer :tries

  public

  attr_reader :tries

  def initialize(secret_code)
    @secret_code = secret_code
    @correct_color = 0
    @correct_pos = 0
    @tries = 0
    make_guess
  end

  def decoded?
    if guess.eql?(secret_code)
      true
    else
      self.correct_pos, self.correct_color = 0, 0
      guess.each_with_index do |color, i|
        if color == secret_code[i]
          self.correct_pos += 1
        elsif secret_code.any?(color)
          self.correct_color += 1
        end
      end
      false
    end
  end

  def feedback
    puts "  "
    print "   #{guess}"
    print "    ", "*" * correct_pos
    print '+' * correct_color
    puts "  "
  end

  def make_guess
    12.times do |turn|
      print "\n  \##{turn + 1}. Please enter your guess>> "
      @guess = gets.chomp.upcase.split('')
      if decoded?
        puts "  "
        print "   #{guess}"
        puts "\n  Congratulations! You cracked the code!"
        break
      end
      feedback
      self.tries += 1
    end
  end
end

Mastermind.new
