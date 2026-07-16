/**
 * FreeLLMAPI Model Discovery Extension
 *
 * Fetches all models from the local FreeLLMAPI instance at startup and
 * registers them as pi models. Models appear in /model and --list-models
 * automatically — no need to hardcode them in models.json.
 *
 * Usage: place in ~/.pi/agent/extensions/freellmapi-discovery/index.ts
 *       then run /reload or restart pi.
 *
 * The apiKey reads from auth.json using a shell command.
 * Make sure freellmapi is configured in auth.json (e.g. via /login).
 */

import { readFileSync } from "node:fs";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const FREEALLMAPI_BASE_URL = "http://localhost:3001";
const FREEALLMAPI_AUTH_PATH = join(process.env.HOME ?? "", ".pi", "agent", "auth.json");

// Models that are FreeLLMAPI meta-operations, not real providers — skip them.
const META_MODELS = new Set(["auto", "fusion"]);

// Known vision-capable model name substrings (heuristic, based on provider knowledge).
const VISION_KEYWORDS = [
  "vision", "vl", "gemma-4.6v", "glm-4.6v", "gemini", "llama-4",
  "kimi", "minimax", "4o", "gpt-4o", "claude", "pix", "image",
];

function guessSupportsVision(id: string): boolean {
  const lower = id.toLowerCase();
  return VISION_KEYWORDS.some((kw) => lower.includes(kw));
}

function guessIsReasoning(id: string): boolean {
  const lower = id.toLowerCase();
  return (
    lower.includes("reasoning") ||
    lower.includes("r1") ||
    lower.includes("think") ||
    lower.includes("distill") ||
    lower.includes("ultra") ||
    lower.includes("super") ||
    lower.includes("nemotron-3-ultra")
  );
}

function getApiKey(): string | undefined {
  try {
    const raw = readFileSync(FREEALLMAPI_AUTH_PATH, "utf-8");
    const auth = JSON.parse(raw) as Record<string, { key?: string; type?: string }>;
    return auth["freellmapi"]?.key;
  } catch {
    return undefined;
  }
}

export default async function (pi: ExtensionAPI) {
  const apiKey = getApiKey();
  const headers: Record<string, string> = {
    "Content-Type": "application/json",
  };
  if (apiKey) {
    headers["Authorization"] = `Bearer ${apiKey}`;
  }

  let models: Array<{
    id: string;
    name: string;
    context_window?: number;
    context_length?: number;
    available?: boolean;
    unavailable_reason?: string;
  }> = [];

  try {
    const response = await fetch(`${FREEALLMAPI_BASE_URL}/v1/models`, { headers });
    if (!response.ok) {
      console.error(
        `[freellmapi-discovery] GET /v1/models failed: ${response.status} ${response.statusText}`,
      );
      return;
    }
    const payload = (await response.json()) as { data: typeof models; list?: typeof models };
    models = payload.data ?? payload.list ?? [];
  } catch (err) {
    console.error("[freellmapi-discovery] Failed to fetch model list:", err);
    return;
  }

  const registeredModels = models
    .filter((m) => !META_MODELS.has(m.id))
    .filter((m) => m.available !== false || m.unavailable_reason === undefined)
    .map((m) => {
      const id = m.id;
      const name = m.name ?? id;
      const cw = m.context_window ?? m.context_length ?? 128000;
      const supportsVision = guessSupportsVision(id);
      const reasoning = guessIsReasoning(id);

      return {
        id,
        name,
        reasoning,
        input: (supportsVision ? ["text", "image"] : ["text"]) as ("text" | "image")[],
        contextWindow: cw,
        maxTokens: Math.min(cw, 262144),
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        compat: {
          // FreeLLMAPI is OpenAI-compatible; some providers (Groq, Cerebras) need system role
          supportsDeveloperRole: false,
        },
      };
    });

  if (registeredModels.length === 0) {
    console.warn("[freellmapi-discovery] No available models found in FreeLLMAPI response.");
    return;
  }

  pi.registerProvider("freellmapi", {
    name: "FreeLLMAPI",
    baseUrl: `${FREEALLMAPI_BASE_URL}/v1`,
    apiKey: apiKey ?? "",
    api: "openai-completions",
    models: registeredModels,
  });

  console.log(
    `[freellmapi-discovery] Registered ${registeredModels.length} models from FreeLLMAPI.`,
  );
}