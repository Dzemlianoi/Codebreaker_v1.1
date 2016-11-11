module Codebreaker
  class Game
    attr_accessor :options, :current_code, :result
    PATH = 'lib/codebreaker/data/'
    EXTENSION = '.yml'

    def initialize
      @phrases = load('phrases')
      @difficulties = load('difficulties')
      @stats = []
      self.options = {}
    end

    def start
      scenario = ''
      puts @phrases[:hello]
      until %w('new stats).include?(scenario)
        scenario = gets.chomp.downcase
      end

      send(scenario.to_s)
    end

    def new
      ask_name
      ask_difficulty
      options[:secret_code] = generate_secret_code
      answer_operations
    end

    def stats
      if first_play?
        puts @phrases[:no_stats]
      else
        stats_load
        stat_describe
      end
      new
    end

    def first_play?
      !File.exist?("#{PATH}statistics#{EXTENSION}")
    end

    def stats_load
      @stats = load('statistics')
    end

    def stat_describe
      @stats.each do |game|
        puts "Codebreaker: #{game[:name]}\n
              Difficulty: #{game[:difficulty]}\n
              Attempts: #{game[:attempts_left]}/#{game[:attempts]}\n
              Hints: #{game[:hints_left]}/#{game[:hints]}\n"
      end
    end

    def answer_operations
      puts @phrases[:hint_info]
      puts @phrases[:ask_answer]

      while options[:attempts_left].positive?
        input = gets.chomp.downcase
        hint?(input) ? show_hint : retrive_answer(input)
        return save_result if win?
      end
      loose
    end

    def hint?(input)
      input.downcase == 'hint'
    end

    def retrive_answer(input)
      self.current_code = input
      options[:attempts_left] -= 1
      return puts @phrases[:win] if win?
      puts comparision_result
    end

    private

    def ask_name
      puts @phrases[:ask_name]
      while options[:name].nil? || options[:name].empty?
        options[:name] = gets.chomp
      end
    end

    def ask_difficulty
      show_difficulty_message

      until @difficulties.keys.include? options[:difficulty]
        options[:difficulty] = gets.chomp.to_sym
      end

      options[:hints] = @difficulties[options[:difficulty]][:hints]
      options[:hints_left] = options[:hints].to_i
      options[:attempts] = @difficulties[options[:difficulty]][:attempts]
      options[:attempts_left] = options[:attempts].to_i
    end

    def show_difficulty_message
      puts @phrases[:ask_difficulty]
      @difficulties.each do |diff, details|
        puts " - #{diff}\n
              Max hints: #{details[:hints]}\n
              Max attemts: #{details[:attempts]}\n"
      end
      puts @phrases[:ask_difficulty_choice]
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def show_hint
      return puts @phrases[:no_hints] if options[:hints_left].zero?
      options[:hints_left] -= 1
      puts "#{@phrases[:hints_left]} #{options[:hints_left]}"
      puts "#{@phrases[:right_digit]} #{options[:secret_code][rand(4)]}"
    end

    def win?
      current_code == options[:secret_code]
    end

    def loose
      puts @phrases[:loose]
      puts @phrases[:right_code] << options[:secret_code]
    end

    def number_of_pluses
      @pluses = []
      input_code = current_code.split('')
      secret_code = options[:secret_code].split('')
      input_code.each_index do |k|
        @pluses.push(k) if input_code[k] == secret_code[k]
      end
      @pluses.size
    end

    def number_of_minuses
      input_code = current_code.split('')
      secret_code = options[:secret_code].split('')
      @pluses.each do |k|
        input_code[k] = nil
        secret_code[k] = nil
      end
      @minuses = input_code.compact & secret_code.compact
      @minuses.size
    end

    def comparision_result
      '+' * number_of_pluses << '-' * number_of_minuses
    end

    def save_result
      @stats = load('statistics')
      @stats.push(options)
      save('statistics', @stats)
    end

    def load(file_name)
      file_name = PATH + file_name + EXTENSION.to_s
      return YAML.load(File.open(file_name)) if File.exist?(file_name)
      File.new(file_name, 'w')
      @stats = []
    end

    def save(file_name, data_object)
      full_path = PATH.to_s + file_name.to_s + EXTENSION
      data = YAML.dump(data_object)
      File.new(full_path, 'w') unless File.exist?(full_path)
      File.write(full_path, data)
    end
  end
end
