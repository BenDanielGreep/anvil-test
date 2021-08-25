# Word Machine

Hi! Welcome to my code. I had a great time working on these challenges.
I've written it in Ruby

## Installation

I use three gems which will need local installation using:
```bash
$ gem install 'json'
$ gem install 'rest-client'
$ gem install 'rufus-scheduler'
```

## Usage

Run the following in your command lines for each file: 

one (You'll need to provide a URL): 

```bash
ruby -r "./one.rb" -e "WordMachine.new.get_words 'INSERT_URL_HERE'"
```
two (URLs are provided in this example):
```bash
 ruby -r "./two_remastered.rb" -e "FancyWordMachine.new.thread_machine 'https://dev-assessment.anvil.app/_/api/docs/1?slow=true,  https://dev-assessment.anvil.app/_/api/docs/2?slow=true, https://dev-assessment.anvil.app/_/api/docs/3?slow=true'"
```
The command line inputs are given at the start of each file.

## Update w/c 23/08/2021

Challenge two has been somewhat rewritten. It is much more efficient as each piece of text is only ever being analysed once, instead of every time a 'snapshot' is called. 
Furthermore, each snapshot now only includes real words, and not half-words. This  was the more technically challenging section of code to write. There might be further refinements to the method that splits the words, but for now it does what's required.

NB I'm aware of two empty spaces being counted, and the issue is being fixed on an ongoing basis. 

Thank you again for your time in reading and reviewing my code!
