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
 ruby -r "./two.rb" -e "FancyWordMachine.new.thread_machine 'https://dev-assessment.anvil.app/_/api/docs/1?slow=true,  https://dev-assessment.anvil.app/_/api/docs/2?slow=true, https://dev-assessment.anvil.app/_/api/docs/3?slow=true'"
```
The command line inputs are also given at the start of each file.

