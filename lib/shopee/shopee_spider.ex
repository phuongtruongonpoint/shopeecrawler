defmodule ShopeeSpider do
  require Logger

  alias Hello.Shopee

  def start_default() do
    start("https://shopee.vn/api/v4/search/search_items?by=pop&limit=30&match_id=88201679&newest=0&order=desc&page_type=shop&scenario=PAGE_OTHERS&version=2")
  end

  def start(url) do
    list_products = fetch(url)
    store_data(list_products)
    %{:ok => list_products}
  end

  def fetch(url) do
    response = Crawly.fetch(url)
    {:ok, body} = Jason.decode(response.body)

    case body["error"] do
      data when data in [nil, 0] ->
        Enum.map(body["items"], fn item ->
          %{
            :name => item["item_basic"]["name"],
            :image => item["item_basic"]["image"],
            :price => item["item_basic"]["price"],
            :category_id => item["item_basic"]["catid"],
            :stock => item["item_basic"]["stock"],
            :sku => item["item_basic"]["itemid"]
          }
        end)
      _ -> []
    end
  end

  def store_data(items) do
    for item <- items do
      case Shopee.create_product(item) do
        {:ok, product} -> Logger.info(product.name <> " has been inserted!")
        {:error, %Ecto.Changeset{} = changeset} -> Logger.warn("failed!")
      end
    end
  end
end
