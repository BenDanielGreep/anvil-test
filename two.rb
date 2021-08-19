# To run, use the following in your command line:
# ruby -r "./two.rb" -e "FancyWordMachine.new.thread_machine 'https://dev-assessment.anvil.app/_/api/docs/1?slow=true,  https://dev-assessment.anvil.app/_/api/docs/2?slow=true, https://dev-assessment.anvil.app/_/api/docs/3?slow=true'"

require 'rest-client'
require 'json'
require 'rufus-scheduler'

class FancyWordMachine
  def initialize
    @total_words_so_far = []
    @total_words_after_processing = []
    @scheduler = Rufus::Scheduler.new
    p 'Fancy Word Machine initialized'
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

  def every_ten_seconds
    @scheduler.every '10s' do
      if @url_process_counter == @url_length
        puts 'Fancy Word Machine finshed. Final output below:'
        count_words(@total_words_after_processing)
        @scheduler.shutdown
      else
        p 'Word count so far:'
        count_words(@total_words_so_far)
      end
    end
    @scheduler.join
  end

  def url_start_here(url, index)
    p "url thread #{index + 1} initialized"
    get_words(url, index)
  end

  def get_words(url, index)
    response = RestClient.get(url)
    result = JSON.parse(response)
    @separate_paragraphs[index] << result['text']
    @total_words_so_far << result['text']
    if result.key?('next_page')
      get_words(result['next_page'], index)
    else
      @total_words_after_processing << @separate_paragraphs[index]
      @url_process_counter += 1
      p "url #{index + 1} done processing"
    end
  end

  def count_words(paragraph)
    words = paragraph.join('').split(' ')
    frequencies = Hash.new(0)
    words.each { |word| frequencies[word.downcase.gsub(/\W+/, '').gsub("\n", ' ')] += 1 }
    sort_words(frequencies)
  end

  def sort_words(frequencies)
    sorted = frequencies.sort { |(k1, v1), (k2, v2)| v1 == v2 ? k1 <=> k2 : v2 <=> v1 }.to_h
    sorted.each do |key, value|
      puts "#{key}:#{value}"
    end
  end
end
