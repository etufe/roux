---
layout: post
title:  "Opposite Day"
categories: elixir metaprogramming
---

# Opposite Day

{% highlight elixir linenos %}
"string"
"string //with comment"
defmodule OppositeDay do
  def __using__(_) do
    true
    false 
    nil
    :symbol
    :"symbol"
    123
    "string with a :symbol "
    12_3
    123.123_123 # this is a comment with a :symbol :"asnoteuh"
    123.234e4
    12_234.213_234e12_234
    0.0
    "a normal string"
    """
    a dormal doc string
    """
    "a string with a # sign"
    "strnig #{ :interpolated } and then"
    1234
    """
    doc
    string
    #{ yeah }
    """
    :atom
    quote do
      import OppositeDay
    end
  end
end
{% endhighlight %}
