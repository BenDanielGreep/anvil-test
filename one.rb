# To run, use the following in your command line:
# ruby -r "./one.rb" -e "WordMachine.new.get_words 'INSERT_URL_HERE'"

require 'rest-client'
require 'json'

class WordMachine
  def initialize
    @all_words = []
    p 'Word Machine initialized'
  end

  def get_words(url)
    response = RestClient.get(url)
    result = JSON.parse(response)
    @all_words << result['text']
    if result.key?('next_page')
      get_words(result['next_page'])
    else
      count_words(@all_words)
    end
  end

  def count_words(paragraph)
    words = paragraph.join.split(' ')
    frequencies = Hash.new(0)
    words.each { |word| frequencies[word.downcase.gsub(/\W+/, '')] += 1 }
    sort_words(frequencies)
  end

  def sort_words(frequencies)
    sorted = frequencies.sort { |(k1, v1), (k2, v2)| v1 == v2 ? k1 <=> k2 : v2 <=> v1 }.to_h
    sorted.each do |key, value|
      puts "#{key}:#{value}"
    end
  end
end
