module Codebreaker
  class Game
    attr_accessor :options, :current_code, :result, :render
    ALLOWED_SCENARIOS = %w(new exit load)

    def initialize
      @difficulties = Loader.load('difficulties')
      @stats = []
      self.render = Render.new
      self.options = {}
      render.hello
    end

    def start
      scenario = gets.chomp.downcase
      return send(scenario.to_s) if ALLOWED_SCENARIOS.include? scenario
      start
    end

    def stats
      first_play? ? render.no_stats : render.stat_describe(@stats)
      start
    end

    def first_play?
      !File.exist?("#{PATH}statistics#{EXTENSION}")
    end

    def game
      render.answers_hints_info
      (0..options[:attempts_left]).each do |val|
        input = gets.chomp.downcase
        hint?(input) ? show_hint : handle_answer(input)
        return save_result if win?
      end
      render.loose(options[:secret_code])
    end

    def hint?(input)
      input.downcase == 'hint'
    end

    def handle_answer(input)
      self.current_code = input
      options[:attempts_left] -= 1
      code_result
    end

    private

    def new
      confirm_settings
      options[:secret_code] = generate_secret_code
      game
    end

    def confirm_settings
      render.ask_name
      options[:name] = gets.chomp
      render.difficulties_show(@difficulties)
      options[:difficulty] = gets.chomp.to_sym

      return ask_settings unless options_right?
      asign_options
    end

    def options_right?
      return !options[:name].nil? && @difficulties.include?(options[:difficulty])
    end

    def asign_options
      options[:hints] = @difficulties[options[:difficulty]][:hints]
      options[:hints_left] = options[:hints].to_i
      options[:attempts] = @difficulties[options[:difficulty]][:attempts]
      options[:attempts_left] = options[:attempts].to_i
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def show_hint
      return render.no_hints if options[:hints_left].zero?
      options[:hints_left] -= 1
      render.hints_left_info(options[:hints_left], options[:secret_code][rand(4)])
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
      puts options[:secret_code]
      puts answer
    end

    def save_result
      @stats = Loader.load('statistics')
      @stats.push(options)
      Loader.save('statistics', @stats)
    end
  end
end
