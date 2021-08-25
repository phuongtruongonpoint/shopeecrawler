defmodule Hello.Shopee.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :category_id, :integer
    field :image, :string
    field :name, :string
    field :price, :integer
    field :stock, :integer
    field :sku, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :image, :price, :stock, :category_id, :sku])
    |> validate_required([:name, :image, :price, :stock, :category_id, :sku])
  end
end
