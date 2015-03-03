---
layout: post
title:  "Opposite Day"
categories: elixir metaprogramming
---
{% highlight elixir linenos %}
1 + 1 > 123 == 123_23423
defmodule OppositeDay do
  def __using__(_opts) do
    quote do
      import OppositeDay
    end
  end
end
{% endhighlight %}

osaneuthsanteohu sanoteuhastoehu
aoentuhasnoteuhazz

{% highlight elixir linenos %}
defmodule TodayIs do
  use OppositeDay    # <- Calls OppositeDay.__using__
end

defmodule OppositeDay do
  defmacro __using__(_opts) do
    quote do               # <- start generating code
      import OppositeDay   # <- generate an import statement
    end                    # <- stop generating code
  end

  defmacro opposite_day([do: block]) do
    do_opposite(block)
  end

  def do_opposite({:-, c, a}) do
    {:+, c, a}
  end

  def do_opposite({:+, c, a}) do
    {:-, c, a}
  end
end

defmodule TodayIs do
  use OppositeDay    # <- Calls OppositeDay.__using__

  IO.inspect(opposite_day do
    4 - 2
  end)
end
{% endhighlight %}
