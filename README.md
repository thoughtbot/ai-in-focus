# AI in Focus Sample Code

This is sample code from our video series, [AI in Focus].

The prompt class is a very basic class for communicating with OpenAI's ChatGPT. Its the code we code we build upon for most of the series.

The sample code doesn't run on its own. It uses the [ruby-openai]
and [tiktoken_ruby] gems, as well as ActiveModel and an application specific `Repository` and `Search` classes to retrieve relevant documents for context.

[ruby-openai]: https://github.com/alexrudall/ruby-openai
[tiktoken_ruby]: https://github.com/IAPark/tiktoken_ruby
[AI in Focus]: https://thoughtbot.com/ai-in-focus-series
