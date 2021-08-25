# To run, use the following in your command line:
# ruby -r "./two_remastered.rb" -e "FancyWordMachine.new.thread_machine 'https://dev-assessment.anvil.app/_/api/docs/1?slow=true,  https://dev-assessment.anvil.app/_/api/docs/2?slow=true, https://dev-assessment.anvil.app/_/api/docs/3?slow=true'"

require 'rest-client'
require 'json'
require 'rufus-scheduler'

class FancyWordMachine
  def initialize
    @frequencies = Hash.new(0)
    @scheduler = Rufus::Scheduler.new
    p 'Fancy Word Machine 2.0 initialized'
  end

  def thread_machine(urls)
    urls = urls.split(/[,\s]+/)
    @url_process_counter = 0
    @url_length = urls.length
    @separate_paragraphs = Array.new(urls.length) { [] }

    threads = []
    threads << Thread.new { every_ten_seconds }

    urls.each_with_index do |url, index|
      threads << Thread.new { url_start_here(url, index) }
    end
    threads.map(&:join)
  end

  def url_start_here(url, index)
    p "url thread #{index + 1} initialized"
    get_words(url, index)
  end

  def every_ten_seconds
    @scheduler.every '10s' do
      if @url_process_counter == @url_length
        puts 'Fancy Word Machine finshed. Final output below:'
        @scheduler.shutdown
      else
        p 'Word count so far:'
      end
      sort_and_print_words
    end
    @scheduler.join
  end

  def get_words(url, index)
    response = RestClient.get(url)
    result = JSON.parse(response)
    paragraph = @separate_paragraphs[index]
    paragraph << split_line(result['text'])

    select_words_to_count(index)

    if result.key?('next_page')
      get_words(result['next_page'], index)
    else
      count_last_word(paragraph.last)
      @url_process_counter += 1
      p "url #{index + 1} done processing"
    end
  end

  def select_words_to_count(index)
    paragraph = @separate_paragraphs[index]
    paragraph.flatten!
    new_selection = paragraph.length > 4 ? paragraph[-4..-2] : paragraph.first(3)
    count_words(new_selection)
  end

  def count_words(selection)
    words = selection.join.split(/\s+/)
    words.each { |word| @frequencies[word.downcase.gsub(/\W+/, ' ')] += 1 }
  end

  def count_last_word(word)
    @frequencies[word.strip] += 1
  end

  def sort_and_print_words
    sorted = @frequencies.sort { |(k1, v1), (k2, v2)| v1 == v2 ? k1 <=> k2 : v2 <=> v1 }.to_h
    sorted.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  def split_line(line)
    results = []
    text_bulk = line.split
    text_bulk.pop
    text_bulk.shift
    results << line.scan(/\A^(\W*\w+)/)
    results << text_bulk.join(' ').prepend(' ') + ' '
    results << line.scan(/\s+(\w+\W*)\z/)
    results.flatten!.each { |l| l.gsub!(/[^0-9a-zA-Z ]/, '') }
    results.each(&:downcase!)
  end
end
