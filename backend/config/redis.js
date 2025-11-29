import { createClient } from "redis";

let redis = null;
let redisStatus = "disconnected"; // connected | disconnected | reconnecting | error

/**
 * Initialize Redis safely
 */
export async function initRedis() {
  try {
    const url = process.env.REDIS_URL;
    if (!url) {
      console.warn("⚠️ No REDIS_URL provided — cache disabled.");
      redisStatus = "disabled";
      return null;
    }

    redis = createClient({
      url,
      socket: {
        connectTimeout: 8000,
        reconnectStrategy: (retries) => {
          redisStatus = "reconnecting";
          return Math.min(retries * 200, 3000);
        }
      }
    });

    // Events
    redis.on("connect", () => {
      console.log("Redis: Connecting...");
      redisStatus = "connecting";
    });

    redis.on("ready", () => {
      console.log("Redis: Connected & ready");
      redisStatus = "connected";
    });

    redis.on("reconnecting", () => {
      console.log("Redis: Reconnecting...");
      redisStatus = "reconnecting";
    });

    redis.on("end", () => {
      console.log("Redis: Connection closed");
      redisStatus = "disconnected";
    });

    redis.on("error", (err) => {
      console.error("Redis Error:", err.message);
      redisStatus = "error";
    });

    // Attempt connection but DO NOT block startup
    redis.connect().catch((err) => {
      console.error("Redis startup failed:", err.message);
      redisStatus = "error";
    });

    return redis;
  } catch (err) {
    console.error("Redis init crashed:", err.message);
    redisStatus = "error";
    return null;
  }
}

/**
 * Check connection state
 */
export function isRedisConnected() {
  return redisStatus === "connected";
}

/**
 * Get Redis client (even if disconnected)
 */
export function getRedisClient() {
  return redis;
}

/**
 * Graceful shutdown
 */
export async function closeRedis() {
  if (!redis) return;
  try {
    await redis.quit();
    console.log("Redis: Connection closed");
  } catch (err) {
    console.error("Redis close error:", err.message);
  }
}

/**
 * Health check (NEVER kills backend)
 */
export async function redisHealthCheck() {
  if (redisStatus === "disabled") {
    return { status: "disabled", message: "Redis not configured" };
  }

  if (!redis || redisStatus !== "connected") {
    return { status: redisStatus, message: "Redis not connected" };
  }

  try {
    await redis.ping();
    return { status: "connected", message: "Redis operational" };
  } catch (err) {
    return { status: "error", message: err.message };
  }
}
