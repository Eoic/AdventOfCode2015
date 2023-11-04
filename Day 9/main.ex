defmodule Dijkstra do
  def get_vertex_with_dist(dist, available_vertices, sorter) do
    available_vertices
    |> Enum.with_index()
    |> sorter.(fn {vertex, index} -> Map.get(dist, vertex, :infinity) end)
  end

  def get_neighbors_in_queue(queue, neightbors_map, vertex) do
    all_neighbors =
      neightbors_map
      |> Map.get(vertex, MapSet.new())
      |> MapSet.to_list()

    Enum.reject(queue, fn item -> not Enum.member?(all_neighbors, item) end)
  end

  def process_queue(dist, prev, graph, []), do: [dist, prev]

  def process_queue(dist, prev, graph, queue) do
    {vertex_min, vertex_min_idx} = get_vertex_with_dist(dist, queue, &Enum.min_by/2)
    new_queue = List.delete_at(queue, vertex_min_idx)

    neighbors_in_queue = get_neighbors_in_queue(queue, Map.get(graph, :neighbors), vertex_min)

    Enum.reduce(neighbors_in_queue, [dist, prev], fn neighbor_v, [dist_acc, prev_acc] ->
      edges = Map.get(graph, :edges)
      alt = Map.get(dist_acc, vertex_min) + Map.get(edges, [vertex_min, neighbor_v], Map.get(edges, [neighbor_v, vertex_min]))

      if alt < Map.get(dist_acc, neighbor_v) do
        [Map.put(dist_acc, neighbor_v, alt), Map.put(prev_acc, neighbor_v, vertex_min)]
      else
        [dist, prev]
      end
    end)
  end

  def search(graph, source, dist \\ %{}, prev \\ %{}, queue \\ []) do
    [dist, prev, queue] =
      graph
      |> Map.get(:vertices)
      |> Enum.reduce([dist, prev, queue], fn vertex, [dist_acc, prev_acc, queue_acc] ->
        [
          Map.put(dist_acc, vertex, :infinity),
          Map.put(prev_acc, vertex, nil),
          queue_acc ++ [vertex]
        ]
      end)

    dist = Map.put(dist, source, 0)
    process_queue(dist, prev, graph, queue)
  end
end

defmodule DayNine do
  @input_path "input.txt"

  def get_input do
    [vertices, edges, neighbors] =
      @input_path
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce([MapSet.new(), %{}, %{}], fn token, [vertices, edges, neighbors] ->
        [edges_repr, distance] = String.split(token, " = ")
        [from, to] = String.split(edges_repr, " to ")
        [
          vertices
          |> MapSet.put(from) |> MapSet.put(to),

          edges
          |> Map.put([from, to], String.to_integer(distance))
          |> Map.put([to, from], String.to_integer(distance)),

          neighbors
          |> Map.update(from, MapSet.new([to]), fn items -> MapSet.put(items, to) end)
          |> Map.update(to, MapSet.new([from]), fn items -> MapSet.put(items, from) end)
        ]
      end)

    %{:vertices => MapSet.to_list(vertices), :edges => edges, :neighbors => neighbors}
  end

  def compute_road_dist(current_vertex, graph, type, visited_vertices \\ [], total_dist \\ 0) do
    all_vertices = Map.get(graph, :vertices)

    if length(visited_vertices) < length(all_vertices) - 1 do
      [dist, _] = Dijkstra.search(graph, current_vertex)
      visited_vertices = [current_vertex | visited_vertices]
      next_vertices = Enum.filter(all_vertices, fn vertex -> not Enum.member?(visited_vertices, vertex) end)
      {vertex_min, _} = Dijkstra.get_vertex_with_dist(dist, next_vertices, (if type == :min, do: &Enum.min_by/2, else: &Enum.max_by/2))
      compute_road_dist(vertex_min, graph, type, visited_vertices, total_dist + Map.get(dist, vertex_min))
    else
      total_dist
    end
  end

  def part_one(graph) do
    graph
    |> Map.get(:vertices)
    |> Enum.map((&compute_road_dist(&1, graph, :min)))
    |> Enum.min()
  end

  def part_two(graph) do
    graph
    |> Map.get(:vertices)
    |> Enum.map((&compute_road_dist(&1, graph, :max)))
    |> Enum.max()
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}")
    IO.puts("Part two: #{part_two(data)}")
  end
end

DayNine.run()
