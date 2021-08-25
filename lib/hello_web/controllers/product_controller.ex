defmodule HelloWeb.ProductController do
  use HelloWeb, :controller

  alias Hello.Shopee
  alias Hello.Shopee.Product

  def index(conn, _params) do
    items = Shopee.list_products()
    render(conn, "index.html", items: items)
  end
end
