defmodule DayXYZ do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
  end

  def part_one(data) do
    :noop
  end

  def part_two(data) do
    :noop
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayXYZ.run()
