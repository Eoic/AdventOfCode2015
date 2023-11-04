defmodule DayFive do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\n")
  end

  def has_enough_vowels?(token) do
    vowels = ["a", "e", "i", "o", "u"]

    token
    |> String.graphemes()
    |> Enum.filter(fn character -> Enum.member?(vowels, character) end)
    |> Enum.count() >= 3
  end

  def has_enough_pairs?(token) do
    uniq_characters =
      token
      |> String.graphemes()
      |> Enum.uniq()

    Enum.reduce(uniq_characters, 0, fn character, pair_count ->
      pair_count + if String.contains?(token, "#{character}#{character}"), do: 1, else: 0
    end) >= 1
  end

  def has_forbidden_substrings?(token) do
    String.contains?(token, ["ab", "cd", "pq", "xy"])
  end

  def has_repeating_pairs?(token) do
    pairs =
      token
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.join/1)
      |> Enum.uniq()

    Enum.reduce_while(pairs, false, fn pair, _ ->
      {:ok, pattern} = Regex.compile(pair)

      if Regex.scan(pattern, token) |> length() >= 2,
         do: {:halt, true},
         else: {:cont, false}
    end)
  end

  def has_valid_triplet?(token) do
    token
    |> String.graphemes()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.uniq()
    |> Enum.filter(fn pair ->
      tokens = String.graphemes(pair)
      List.first(tokens) == List.last(tokens)
    end)
    |> length() >= 1
  end

  def part_one(data) do
    is_nice? = &(has_enough_vowels?(&1) and !has_forbidden_substrings?(&1) and has_enough_pairs?(&1))

    Enum.reduce(data, 0, fn token, count ->
      count + if is_nice?.(token), do: 1, else: 0
    end)
  end

  def part_two(data) do
    is_nice? = &(has_repeating_pairs?(&1) and has_valid_triplet?(&1))

    Enum.reduce(data, 0, fn token, count ->
      count + if is_nice?.(token), do: 1, else: 0
    end)
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayFive.run()
