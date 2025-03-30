# codegen: do not edit
defmodule MCP.Protocol.Notifications do
  import Schematic

  def new(notification) do
    unify(
      oneof(fn
        %{"method" => "notifications/cancelled"} ->
          MCP.Protocol.Notifications.CancelledNotification.schematic()

        %{"method" => "notifications/initialized"} ->
          MCP.Protocol.Notifications.InitializedNotification.schematic()

        %{"method" => "notifications/progress"} ->
          MCP.Protocol.Notifications.ProgressNotification.schematic()

        %{"method" => "notifications/roots/list_changed"} ->
          MCP.Protocol.Notifications.RootsListChangedNotification.schematic()

        %{"method" => "notifications/resources/list_changed"} ->
          MCP.Protocol.Notifications.ResourceListChangedNotification.schematic()

        %{"method" => "notifications/resources/updated"} ->
          MCP.Protocol.Notifications.ResourceUpdatedNotification.schematic()

        %{"method" => "notifications/prompts/list_changed"} ->
          MCP.Protocol.Notifications.PromptListChangedNotification.schematic()

        %{"method" => "notifications/tools/list_changed"} ->
          MCP.Protocol.Notifications.ToolListChangedNotification.schematic()

        %{"method" => "notifications/message"} ->
          MCP.Protocol.Notifications.LoggingMessageNotification.schematic()

        _ ->
          {:error, "unexpected notification payload"}
      end),
      notification
    )
  end
end
