defmodule Explorer.Chain.Cache.NetVersion do
  @moduledoc """
  Caches chain version.
  """

  require Logger

  use Explorer.Chain.MapCache,
      name: :net_version,
      key: :version

  defp handle_fallback(:version) do
    case EthereumJSONRPC.fetch_net_version(Application.get_env(:explorer, :json_rpc_named_arguments)) do
      {:ok, value} ->
        if value == 1 do
          {:update, 321}
        else
          {:update, value}
        end

      {:error, reason} ->
        Logger.debug(
          [
            "Coudn't fetch net_version, reason: #{inspect(reason)}"
          ]
        )

        {:return, nil}
    end
  end

  defp handle_fallback(_key), do: {:return, nil}
end
