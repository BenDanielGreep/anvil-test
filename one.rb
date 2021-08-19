# To run, use the following in your command line:
# ruby -r "./one.rb" -e "WordMachine.new.get_words 'INSERT_URL_HERE'"

require 'rest-client'
require 'json'

class WordMachine
  def initialize
    @all_words = []
    p 'Word Machine initialized'
  end

  # Parse the json from the url provided
  def get_words(url)
    response = RestClient.get(url)
    result = JSON.parse(response)
    # Add the word to the array of words
    @all_words << result['text']
    # If there a 'next page' in the JSON then repeat previous steps
    if result.key?('next_page')
      get_words(result['next_page'])
    else
      # If there isn't a 'next page' then count the words
      count_words(@all_words)
    end
  end

  # Count the words
  def count_words(paragraph)
    words = paragraph.join.split(' ')
    frequencies = Hash.new(0)
    # Strip the words of non alpha-numerics and add their frequency to the hash
    words.each { |word| frequencies[word.downcase.gsub(/\W+/, '')] += 1 }
    sort_words(frequencies)
  end

  # Then sort the words
  def sort_words(frequencies)
    sorted = frequencies.sort { |(k1, v1), (k2, v2)| v1 == v2 ? k1 <=> k2 : v2 <=> v1 }.to_h
    # sorted.each { |k, v| print `#{k}:#{v}` }
    sorted.each do |key, value|
      puts "#{key}:#{value}"
    end
  end
end
