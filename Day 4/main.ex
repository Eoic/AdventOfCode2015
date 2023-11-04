defmodule DayFour do
  @input_path "input.txt"

  def get_input, do: File.read!(@input_path)

  def find_hash_number(key, md5_prefix_match, number \\ 1) do
      :crypto.hash(:md5, key <> to_string(number))
      |> Base.encode16()
      |> String.starts_with?(md5_prefix_match)
      |> (fn is_match -> if is_match, do: number, else: find_hash_number(key, md5_prefix_match, number + 1) end).()
  end

  def part_one(data), do: find_hash_number(data, "00000")

  def part_two(data), do: find_hash_number(data, "000000")

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayFour.run()
