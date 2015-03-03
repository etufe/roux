defmodule OppositeDay do
  defmacro __using__(_opts) do
    quote do               # <- start generating code
      import OppositeDay   # <- generate an import statement
    end                    # <- stop generating code
  end

  defmacro opposite_day([do: block]) do
    do_opposite(block)
  end

  # def do_opposite({:-, c, a}), do: {:+, c, a}
  # def do_opposite({:+, c, a}), do: {:-, c, a}
  # def do_opposite({:*, c, a}), do: {:/, c, a}
  # def do_opposite({:/, c, a}), do: {:*, c, a}
  # def do_opposite({:<, c, a}), do: {:>, c, a}
  # def do_opposite({:>, c, a}), do: {:<, c, a}
  # def do_opposite({:==, c, a}), do: {:!=, c, a}
  # def do_opposite({:!=, c, a}), do: {:==, c, a}

  def do_opposite({o, c, a}) when o in [:+, :-, :/, :*, :>, :<, :!=, :==] do
    {case o do
      :-  -> :+
      :+  -> :-
      :*  -> :/
      :/  -> :*
      :>  -> :<
      :<  -> :>
      :== -> :!=
      :!= -> :==
    end, c, a}
  end

  def do_opposite({o, c, a}), do: {o, c, do_opposite(a)}

  def do_opposite(a) when is_list a do
    for statement <- a, do: do_opposite(statement)
  end
end

defmodule TodayIs do
  use OppositeDay    # <- Calls OppositeDay.__using__

  opposite_day do
    IO.puts 4 - 2
    IO.puts 4 + 2
    IO.puts 3 * 3
    IO.puts 12 != 12
    IO.puts 2345 == :a
  end
end
