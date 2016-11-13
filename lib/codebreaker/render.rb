module Codebreaker
  class Render
    def initialize
      @phrases = Loader.load('phrases')
    end

    def hello
      puts @phrases[:hello]
    end

    def no_stats
      puts @phrases[:no_stats]
    end

    def stat_describe(stats)
      stats.each do |game|
        puts "Codebreaker: #{game[:name]}\n
              Difficulty: #{game[:difficulty]}\n
              Attempts: #{game[:attempts_left]}/#{game[:attempts]}\n
              Hints: #{game[:hints_left]}/#{game[:hints]}\n"
      end
    end

    def answers_hints_info
      puts @phrases[:hint_info]
      puts @phrases[:ask_answer]
    end

    def difficulties_show(difficulties)
      puts @phrases[:ask_difficulty]
      difficulties.each do |diff, details|
        puts " - #{diff}\n
             Max hints: #{details[:hints]}\n
             Max attemts: #{details[:attempts]}\n"
      end

      puts @phrases[:ask_difficulty_choice]
    end

    def ask_name
      puts @phrases[:ask_name]
    end

    def loose(secret_code)
      puts @phrases[:loose]
      puts "#{@phrases[:right_code]} #{secret_code}"
    end

    def no_hints
      puts @phrases[:no_hints]
    end

    def hints_left_info(hints_left, random_dig)
      puts "#{@phrases[:hints_left]} #{hints_left}"
      puts "#{@phrases[:right_digit]} #{random_dig}"
    end
  end
end