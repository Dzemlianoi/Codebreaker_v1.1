module Codebreaker
  class Game
    attr_accessor :options, :current_code, :result, :render, :hint_code_digits
    ALLOWED_SCENARIOS = %w(new exit stats)

    def initialize
      @difficulties = Loader.load('difficulties')
      @stats = Loader.load('statistics');
      self.render = Render.new
      self.options = {}
      render.hello
    end

    def start
      scenario = gets.chomp.downcase
      return send(scenario.to_s) if ALLOWED_SCENARIOS.include? scenario
      start
    end

    def game
      render.answers_hints_info
      (0..options[:attempts_left]).each do |val|
        input = gets.chomp.downcase
        hint?(input) ? show_hint : handle_answer(input)
        return win if win?
      end
      render.loose(options[:secret_code])
    end

    def hint?(input)
      input.downcase == 'hint'
    end

    def handle_answer(input)
      self.current_code = input
      return render.wrong_input if code_incorrect?
      options[:attempts_left] -= 1
      code_result
    end

    private

    def new
      confirm_settings
      options[:secret_code]  = generate_secret_code
      self.hint_code_digits = options[:secret_code].clone
      puts options[:secret_code]
      game
    end

    def confirm_settings
      render.ask_name
      options[:name] = gets.chomp while name_incorrect?

      render.difficulties_show(@difficulties)
      options[:difficulty] = gets.chomp.to_sym while diff_incorrect?

      asign_options
    end

    def stats
      first_play? ? render.no_stats : render.stat_describe(@stats)
      start
    end

    def first_play?
      !@stats.any?
    end

    def name_incorrect?
      options[:name].nil? || options[:name].to_s.empty?
    end

    def diff_incorrect?
      !@difficulties.include?(options[:difficulty])
    end

    def asign_options
      options[:hints] = @difficulties[options[:difficulty]][:hints]
      options[:hints_left] = options[:hints].to_i
      options[:attempts] = @difficulties[options[:difficulty]][:attempts]
      options[:attempts_left] = options[:attempts]
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def show_hint
      return render.no_hints if options[:hints_left].zero?
      options[:hints_left] -= 1
      render.hints_left_info(options[:hints_left], get_hint_digit)
    end

    def get_hint_digit
      hint_code_digits.slice!(rand(self.hint_code_digits.size))
    end

    def code_incorrect?
      current_code.match(/^[0-6]{4}$/).nil?
    end

    def win?
      current_code == options[:secret_code]
    end

    def code_result
      answer = ''
      secret_code_copy = options[:secret_code].split('')
      current_code_copy = current_code.split('')
      (0...4).each do |k|
        if options[:secret_code][k] == current_code[k]
          answer << '+'
          current_code_copy[k] = nil
          secret_code_copy[k] = nil
        end
      end
      minuses = current_code_copy.compact & secret_code_copy.compact
      minuses.size.times {answer << '-'}
      puts answer
    end

    def save_result
      @stats = Loader.load('statistics') if @stats.any?
      @stats.push(options)
      Loader.save('statistics', @stats)
    end

    def win
      render.win
      save_result if gets.chomp.downcase == 'y'
    end
  end
end