defmodule SsLvApiWeb.ScraperController do
  use SsLvApiWeb, :controller
  alias HTTPoison

  def create(conn, params) do
    url = params["url"]

    if url do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          # Parse the body with Floki
          parsed_data = parse_table_data(body)
          json(conn, %{data: parsed_data})

        {:error, %HTTPoison.Error{reason: reason}} ->
          conn = put_status(conn, 400)
          json(conn, %{error: reason})
      end
    else
      conn = put_status(conn, 400)
      json(conn, %{error: "URL parameter is required"})
    end
  end


  defp parse_table_data(html_body) do
    # CSS Selector for the rows in the sixth table
    rows_css = "table:nth-of-type(2) tr"

    # Find all rows
    rows = Floki.find(html_body, rows_css)

    # Map each row to a list of its cell data
    rows_data =
      Enum.map(rows, fn row ->
        # Find all cells within the row
        cells = Floki.find(row, "td")
        # Map each cell to its text content
        Enum.map(cells, fn cell -> Floki.text(cell) end)
      end)

    rows_data
  end


end
