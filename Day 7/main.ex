defmodule DaySeven do
  import Bitwise

  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\n")
  end

  def cache_listener(cache \\ %{}) do
    receive do
      {:set, input, value} ->
        cache_listener(Map.put(cache, input, value))
      {:get, input, reply_pid} ->
        send(reply_pid, Map.get(cache, input))
        cache_listener(cache)
      {:reset, initial_state} ->
        cache_listener(initial_state)
    end
  end

  def get_input_value(context, input) do
    send(:cache, {:get, input, self()})

    receive do
      nil ->
        {_, _, value} = send(:cache, {:set, input, Map.get(context, input).(context)})
        value
      value ->
        value
    end
  end

  def apply_expression(states, [input], output, 1) do
    case Integer.parse(input) do
      {value, ""} ->
        Map.put(states, output, fn _ -> value end)
      :error ->
        Map.put(states, output, fn context -> get_input_value(context, input) end)
    end
  end

  def apply_expression(states, [gate, input], output, 2) do
    cond do
      gate === "NOT" ->
        Map.put(states, output, fn context -> 65535 + bnot(get_input_value(context, input)) + 1 end)
    end
  end

  def apply_expression(states, [left_input, gate, right_input], output, 3) do
    case gate do
      "AND" ->
        case Integer.parse(left_input) do
          {left_input_value, ""} -> Map.put(states, output, fn context -> band(left_input_value, get_input_value(context, right_input)) end)
          :error -> Map.put(states, output, fn context -> band(get_input_value(context, left_input), get_input_value(context, right_input)) end)
        end
      "OR" ->
        Map.put(states, output, fn context -> bor(get_input_value(context, left_input), get_input_value(context, right_input)) end)
      "LSHIFT" ->
        Map.put(states, output, fn context -> get_input_value(context, left_input) <<< String.to_integer(right_input) end)
      "RSHIFT" ->
        Map.put(states, output, fn context -> get_input_value(context, left_input) >>> String.to_integer(right_input) end)
    end
  end

  def compute_states(data) do
    Enum.reduce(data, %{}, fn instruction, states ->
      [input, output] = String.split(instruction, " -> ")

      expression =
        input
        |> String.trim()
        |> String.split(" ")

      apply_expression(states, expression, output, Enum.count(expression))
    end)
  end

  def part_one(data) do
    states = compute_states(data)
    {_, _, value} = send(:cache, {:set, "a", Map.get(states, "a").(states)})
    value
  end

  def part_two(data) do
    send(:cache, {:get, "a", self()})

    receive do
      input_a_value -> send(:cache, {:reset, %{"b" => input_a_value}})
    end

    states = compute_states(data)
    Map.get(states, "a").(states)
  end

  def run do
    data = get_input()
    cache_pid = spawn(&cache_listener/0)
    Process.register(cache_pid, :cache)
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DaySeven.run()
