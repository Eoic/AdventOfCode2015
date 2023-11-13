defmodule DayTen do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.trim()
  end

  def generate_sequence(initiator, index \\ 0)

  def generate_sequence(initiator, 40), do: String.length(initiator)

  def generate_sequence(initiator, index) do
    new_sequence =
      initiator
      |> String.graphemes()
      |> Enum.chunk_by(fn item -> item end)
      |> Enum.reduce("", fn tokens, sequence ->
        sequence <> to_string(to_string(length(tokens))) <> hd(tokens)
      end)

    generate_sequence(new_sequence, index + 1)
  end

  def part_one(data) do
    generate_sequence(data)
  end

  # def part_two(data) do
  #   :noop
  # end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    # IO.puts("Part two: #{part_two(data)}")
  end
end

DayTen.run()
