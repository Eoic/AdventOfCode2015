defmodule DaySix do
  @input_path "./input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split("\n")
    |> apply_all_instructions()
  end

  def parse_instruction(token) do
    coordinates =
      token
      |> (&Regex.scan(~r/\d+,\d+/, &1)).()
      |> Enum.map(fn coordinate_token ->
        coordinate_token
        |> hd
        |> String.split(",")
        |> Enum.map(fn number ->
          {int_part, ""} = Integer.parse(number)
          int_part
        end)
      end)

    action = cond do
      String.starts_with?(token, "toggle") -> :toggle
      String.starts_with?(token, "turn on") -> :turn_on
      String.starts_with?(token, "turn off") -> :turn_off
    end

    {action, coordinates}
  end

  def apply_instruction(grid, instruction) do
    {action, [[x0, y0], [x1, y1]]} = parse_instruction(instruction)

    Enum.reduce(x0..x1, grid, fn col, grid_acc_upper ->
      Enum.reduce(y0..y1, grid_acc_upper, fn row, grid_acc_lower ->
        initial_state = case action do
          :turn_off -> %{:is_enabled => false, :brightness => 0}
          :turn_on -> %{:is_enabled => true, :brightness => 1}
          :toggle -> %{:is_enabled => true, :brightness => 2}
        end

        Map.update(grid_acc_lower, [col, row], initial_state, fn state ->
          case action do
            :toggle ->  %{:is_enabled => !state.is_enabled, :brightness => state.brightness + 2}
            :turn_on -> %{:is_enabled => true, :brightness => state.brightness + 1}
            :turn_off -> %{:is_enabled => false, :brightness => (if state.brightness - 1 < 0, do: 0, else: state.brightness - 1)}
          end
        end)
      end)
    end)
  end

  def apply_all_instructions(data) do
    Enum.reduce(data, %{}, fn (instruction, grid) -> apply_instruction(grid, instruction) end)
  end

  def part_one(data) do
    data
    |> Map.filter(fn {_, state} -> state.is_enabled === true end)
    |> map_size()
  end

  def part_two(data) do
    data
    |> Map.values()
    |> Enum.reduce(0, &(&2 + &1.brightness))
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DaySix.run()
