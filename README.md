# Windows CPU Llama Server (OpenAI-Compatible)

This repo runs a local CPU-only LLM server on Windows using llama.cpp.
It’s configured to serve an OpenAI-compatible API on `http://localhost:51113/v1`.

- Binaries: pre-fetched llama.cpp Windows CPU executables (x64)
- Scripts: `chat.ps1` for interactive CLI, `start-server.ps1` for HTTP server
- Model: place a GGUF file next to the scripts (ignored by git)

## Quick Start

1) Place your GGUF model (e.g. `llama-3.2-1b-instruct-q4_k_m.gguf`) in this folder.

2) Start the server on port 51113:

```
./start-server.ps1
```

3) Use the OpenAI API with base URL `http://localhost:51113/v1` and any API key (e.g., `sk-local`).

### Python example
```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:51113/v1", api_key="sk-local")

resp = client.chat.completions.create(
    model="local-gguf",  # any string; llama.cpp ignores it
    messages=[{"role":"user","content":"Say hi from CPU"}],
)
print(resp.choices[0].message.content)
```

### Node.js example
```js
import OpenAI from "openai";
const openai = new OpenAI({ baseURL: "http://localhost:51113/v1", apiKey: "sk-local" });

const resp = await openai.chat.completions.create({
  model: "local-gguf",
  messages: [{ role: "user", content: "Say hi from CPU" }],
});
console.log(resp.choices[0].message.content);
```

## Interactive chat (terminal)
Run an interactive session on CPU only:

```
./chat.ps1
```

## Notes
- CPU-only is enforced with `-ngl 0`.
- Threads are auto-detected; override with `-Threads`.
- The `.gguf` model file is ignored by git to avoid GitHub’s 100 MB limit. Keep it locally or distribute via release/LFS.
- To change the default port: `./start-server.ps1 -Port 51113`.

## OpenAI compatibility
`llama-server` implements:
- `POST /v1/chat/completions`
- `GET /v1/models`
- (legacy) `POST /v1/completions`

Base URL: `http://localhost:51113/v1`

No authentication is enforced by default; add a reverse proxy or modify the startup to require a key if exposing over a network.
