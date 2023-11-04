defmodule DayTwo do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\n")
  end

  def get_dimensions(size) do
    [{length, ""}, {width, ""}, {height, ""}] =
      size
      |> String.split("x")
      |> Enum.map(&Integer.parse/1)

    [length, width, height]
  end

  def part_one(data) do
    Enum.reduce(data, 0, fn size, total_area ->
      dimensions = [length, width, height] = get_dimensions(size)

      min_side_area =
        dimensions
        |> Enum.sort()
        |> Enum.take(2)
        |> Enum.product()
      
      total_area + 2 * length * width + 2 * width * height + 2 * length * height + min_side_area
    end)
  end

  def part_two(data) do
    Enum.reduce(data, 0, fn size, total_area ->
      dimensions = get_dimensions(size)

      min_perimeter =
        dimensions
        |> Enum.sort()
        |> Enum.take(2)
        |> Enum.map(&(&1 * 2))
        |> Enum.sum()

      total_area + min_perimeter + Enum.product(dimensions)
    end)
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayTwo.run()
