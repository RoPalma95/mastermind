class Mastermind
  attr_reader :computer, :user

  WELCOME_MESSAGE = "\n\t\t\tWELCOME TO MASTERMIND\n\n  If you play as the Codemaker, you have to pick four colors from the following options:\n
  \t[R]ed, [G]reen, [Y]ellow, [O]range, [B]lack, [W]hite\n
  Use only the color's initial to input your code, or your guesses if you are playing as the codebreaker.\n
  You will be playing as the Codebreaker against the computer. You have 12 turns to figure out the secret code.
   "
  CODE_OPTIONS = %w[R G Y O B W]

  def initialize
    puts WELCOME_MESSAGE
    @computer = Codemaker.new
    @user = Codebreaker.new(@computer.code)
    puts won?(user.tries)
    # @game_mode = gets.chomp.upcase
  end

  def won?(tries)
    "\n  You ran out of tries. The secret code was #{computer.code}" if tries == 12
  end
end

class Codemaker < Mastermind
  attr_reader :code

  def initialize
    @code = CODE_OPTIONS.sample(4)
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
          self.correct_color +=1
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
        feedback
        puts "\n  Congratulations! You cracked the code!"
        break
      end
      feedback
      self.tries += 1
    end
  end
end

Mastermind.new
