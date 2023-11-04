defmodule DayOne do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.graphemes()
  end

  def get_position_change(token) do
    case token do
      "(" -> 1
      ")" -> -1
    end
  end

  def part_one(data) do
    Enum.reduce(data, 0, fn token, position ->
      position + get_position_change(token)
    end)
  end

  def part_two(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn {token, index}, position ->
      if position === -1 do
        {:halt, index}
      else
        {:cont, position + get_position_change(token)}
      end
    end)
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayOne.run()
