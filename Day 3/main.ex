defmodule DayThree do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.graphemes()
  end

  def get_new_position(token, [x, y]) do
    case token do
      "^" -> [x, y + 1]
      ">" -> [x + 1, y]
      "v" -> [x, y - 1]
      "<" -> [x - 1, y]
    end
  end

  def record_visit(visits_counter, position) do
    Map.update(visits_counter, position, 1, fn count -> count + 1 end)
  end

  def record_all_visits(data, initial_counter \\ %{[0, 0] => 1}) do
    [visits_counter, _] = Enum.reduce(data, [initial_counter, [0, 0]], fn token, [visits_counter, [x, y]] ->
      position = get_new_position(token, [x, y])
      [record_visit(visits_counter, position), position]
    end)

    visits_counter
  end

  def part_one(data) do
    data
    |> record_all_visits()
    |> map_size()
  end

  def part_two(data) do
    [human_steps, robot_steps] =
      data
      |> Enum.with_index()
      |> Enum.reduce([[], []], fn {token, index}, [human_steps, robot_steps] ->
        if rem(index, 2) === 0,
           do: [human_steps ++ [token], robot_steps],
           else: [human_steps, robot_steps ++ [token]]
      end)

    record_all_visits(human_steps) |> (&record_all_visits(robot_steps, &1)).() |> map_size()
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayThree.run()
