---
layout: post
title:  "Opposite Day"
subtitle: "Or how I learned to love the AST."
categories: elixir metaprogramming
---

## Not acceptable adult behaviour
Remember [Oppsite Day][od]? The thought expirement / sibling pestering tool in which the answer to "Is it Opposite Day?" is alway "No" whether or not it is in fact opposite day. It is the enabler of such beautiful playground connundrums as "I'll trade my pudding for your apple on opposite day." Well now that we're older and engaging random people in a good old round of yes-means-no-and-no-means-yes is met with a fear for personal safety, let's convince the computer to play it with us. Or rather let's force it to play, like a younger sibling the computer has no say in the matter. 

## Commanding the machine
In [Elixir](http://elixir-lang.org/) we can, if we so dare, controll the inner workings of the language through [Macros][macros]. The goal of Macros in Elixir is code manipulation and injection. Whenever we call a macro we are giving it access to the raw elixir code that we have written and letting it massage that code into something shiny and new and spit it back into our source. Or in our case relive childhood memories.

## What the Compiler Sees
When writing code we do it in a way thats convenient for humans, and just before compilation it get's converted to be convenient for computers. In Elixir we can get direct access to this 'convienient for computers' structure known as the [Abstract Syntax Tree][ast], or AST, through the [quote][quote] special form. All we gotta do is pass it a block of code, any syntatically valid Elixir, and it'll show us what the compiler would see:

{% highlight elixir %}
> quote do 1 + 3 end
{:+, [context: Elixir, import: Kernel], [1, 3]}

> quote do
   trade_lunch? = fn (mine, theirs) ->
     if mine >= theirs do
       false
     else
       true
     end
   end
 end
{:=, [],
 [{:trade_lunch?, [], Elixir},
  {:fn, [],
   [{:->, [],
     [[{:mine, [], Elixir}, {:theirs, [], Elixir}],
      {:if, [context: Elixir, import: Kernel],
       [{:>=, [context: Elixir, import: Kernel],
         [{:mine, [], Elixir}, {:theirs, [], Elixir}]},
        [do: false, else: true]]}]}]}]}
{% endhighlight %}

That first one looks pretty managable, we see the `+` sign and the variables we gave it. There's some crap in the middle but who cares about that? The second one though, looks like just enough brackets to make me stop right here and give up on the whole metaprogramming craze; leave it to the kids with their pokémon. With just a tiny bit more scrutiny, though, we see that this massive pile of not-my-programming-language that `quote` gave back to us is admittedly just a neatly nested structure of `{function, context, arguments}`. Also that all the pieces are just normal elixir waiting for us to get our grubby hands on.

## Grubby little hands
Let's get dirty, we'll call this file `opposite_day.ex`:
{% highlight elixir linenos %}
defmodule OppositeDay do
  defmacro opposite_day(do: block) do
    IO.inspect block
  end
end
{% endhighlight %}
and in iex we can:
{% highlight elixir %}
> c "opposite_day.ex"
> import OppositeDay
> opposite_day do 1 + 3 end
{:+, [line: 15], [1, 3]}
4
{% endhighlight %}
**Woah** we're in the matrix. The first line of output is the AST of the expression we passed to `OppositeDay.opposite_day`. We didn't have to quote it ourselves because macros receive their arguments already quoted. The next line of output is the result of the expression we passed. IO.inspect prints it's argument but also returs it unchanged which means that our little macro injected the exact AST it got and then iex ran it like normal. Let's get straight to businness and make yes mean no.
{% highlight elixir linenos %}
defmodule OppositeDay do
  defmacro opposite_day(do: block) do
    do_opposite(block)
  end

  def do_opposite({:==, context, arguments}) do
    {:!=, context, arguments}
  end
end
{% endhighlight %}
iex:
{% highlight elixir %}
> c "opposite_day.ex"
> opposite_day do 2 + 2 == 4 end
false
{% endhighlight %}

*Ahahaha* we are masters of the universe! We've bent elixir to our will and it feels good. Let's try some more:
{% highlight elixir %}
> opposite_day do 9 * 3 == 27 end
false
> opposite_day do
    5 == 13 - 8
    144 = 12 * 12
  end
** (FunctionClauseError) no function clause matching in
OppositeDay.do_opposite(:__block__ ...
{% endhighlight %}

Ah crap, ok so if we pass it more than one expression the whole thing gets wrapped in a `{:__block__, context, arguments}` tuple. Let's account for that generically by saying, if we get anything we don't care about pass it through unchanged and check it's arguments. Since the arguments are in a list we'll just enumerate over them:
{% highlight elixir linenos %}
defmodule OppositeDay do
  defmacro opposite_day(do: block) do
    do_opposite(block)
  end

  def do_opposite({:==, context, arguments}) do
    {:!=, context, arguments}
  end

  # If we don't care about the function, check the arguments
  def do_opposite({function, context, arguments}) do
    {function, context, do_opposite(arguments)}
  end

  # If the arguments is a list, check each item
  def do_opposite(arguments) when is_list arguments do
    for statement <- arguments, do: do_opposite(statement)
  end
  
  # if it's something else entirely, just pass it on through
  def do_opposite(x), do: x
end
{% endhighlight %}
iex:
{% highlight elixir %}
> c "opposite_day.ex"
> opposite_day do 
    IO.inspect 2 + 2 == 4
    IO.inspect 144 == 12 * 12
  end
false
false
{% endhighlight %}

## So Close and Too Young for Cigars
Awesome, we're back in business! Lets add some more opposites to complete the game:
{% highlight elixir linenos %}
defmodule OppositeDay do
  defmacro opposite_day(do: block) do
    do_opposite(block)
  end

  def do_opposite({:==, c, a}), do: {:!=, c, a}
  def do_opposite({:!=, c, a}), do: {:==, c, a}
  def do_opposite({:-,  c, a}), do: {:+,  c, a}
  def do_opposite({:+,  c, a}), do: {:-,  c, a}
  def do_opposite({:*,  c, a}), do: {:/,  c, a}
  def do_opposite({:/,  c, a}), do: {:*,  c, a}
  def do_opposite({:<,  c, a}), do: {:>,  c, a}
  def do_opposite({:>,  c, a}), do: {:<,  c, a}

  def do_opposite({function, context, arguments}) do
   {function, context, do_opposite(arguments)}
  end

  def do_opposite(arguments) when is_list arguments do
   for statement <- arguments, do: do_opposite(statement)
  end

  def do_opposite(x), do: x
end
{% endhighlight %}
iex:
{% highlight elixir %}
> c "opposite_day.ex"
> opposite_day do
    IO.puts 13 * 3
    IO.puts 42 + 15
    IO.puts "homework" == "cool"
    i_totally_wanna_trade_snacks = fn -> true end
    IO.puts i_totally_wanna_trade_snacks.() == true
  end
4.333333333333333
27
true
false
{% endhighlight %}

## King of the Sarcastic Playground
We've done it! With just those 20 ish lines of code we re-wrote a bunch of Elixir's built in operators to give us maximum leverage of our sarcastic power. On a more useful note, this basic behaviour is exactly what macros are all about. Grabbing some AST, massaging about the tid-bits you need and plopping it right back in the source. Don't listen to anyones warnings. Metaprogram the be-jesus out of your code until you've got no more cheek space left for grinning. It's an awesome way to get better at programming and it's a barrell full of fun to boot.<br>
&#9876;

<!-- refs -->
[od]: https://en.wikipedia.org/wiki/Opposite_Day
[macros]: http://elixir-lang.org/getting-started/meta/macros.html
[quote]: http://elixir-lang.org/docs/stable/elixir/Kernel.SpecialForms.html#quote/2
[ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
