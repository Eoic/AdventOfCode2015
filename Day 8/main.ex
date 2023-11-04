defmodule DayEight do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\n")
  end

  def part_one(data) do
    [total_code_length, total_string_length] = Enum.reduce(data, [0, 0], fn (string, [code_length, string_length]) ->
      current_string_length = string |> Macro.unescape_string() |> String.length()
      [code_length + byte_size(string), string_length + current_string_length - 2]
    end)

    total_code_length - total_string_length
  end

  def part_two(data) do
    [encoded_length, original_length] = Enum.reduce(data, [0, 0], fn (string, [total_encoded_length, total_original_length]) ->
      processed_string = Macro.to_string(string)
      [total_encoded_length + byte_size(processed_string), total_original_length + byte_size(string)]
    end)

    encoded_length - original_length
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayEight.run()
