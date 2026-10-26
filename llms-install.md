# Installing the Rus.sh MCP server

Rus.sh is a hosted (remote) MCP server. There is nothing to download, build or run locally.

1. Add a remote MCP server named `rus-sh` with this address, using the Streamable HTTP transport:

   ```
   https://rus.sh/mcp
   ```

2. When the client connects, it opens a browser window. Sign in to your Rus.sh account (or create a free one at https://rus.sh/signup) and choose **Allow access**.
3. Check the connection by asking: "List my Rus.sh links."

If the client can't sign in through a browser, it can send an API key instead. Create a key at https://rus.sh/app/api-keys and send it as the header `Authorization: Bearer <key>`.

Full guide for each client: https://rus.sh/pages/ai
