defmodule SsLvApiWeb.ScraperControllerTest do
  use SsLvApiWeb.ConnCase

  describe "POST /api/scraper" do
    test "responds with the expected message", %{conn: conn} do
      params = %{
        #url: "https://www.ss.com/lv/transport/cars/bmw/page5.html"
        url: "https://www.ss.com/lv/real-estate/flats/riga/darzciems/page2.html"
      }
      conn = post(conn, "/api/scraper", params)

      # Decode the JSON response
      response_map = Jason.decode!(conn.resp_body)

      # Access and inspect the rows data within the "data" key
      rows_data = response_map["data"]

      # If you want to inspect the first row
      first_row = Enum.at(rows_data, 0)
      IO.inspect(first_row)

      assert json_response(conn, 200)
    end
  end
end
