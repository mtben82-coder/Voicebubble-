import { createClient } from 'redis';

let redisClient = null;
let isConnected = false;

/**
 * Initialize Redis client
 */
export async function initRedis() {
  try {
    const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
    
    redisClient = createClient({
      url: redisUrl,
      socket: {
        reconnectStrategy: (retries) => {
          if (retries > 10) {
            console.error('Redis: Too many reconnection attempts');
            return new Error('Redis reconnection failed');
          }
          // Exponential backoff: 50ms, 100ms, 200ms, 400ms, etc.
          return Math.min(retries * 50, 3000);
        }
      }
    });

    // Event handlers
    redisClient.on('error', (err) => {
      console.error('Redis Client Error:', err);
      isConnected = false;
    });

    redisClient.on('connect', () => {
      console.log('Redis: Connecting...');
    });

    redisClient.on('ready', () => {
      console.log('Redis: Connected and ready');
      isConnected = true;
    });

    redisClient.on('reconnecting', () => {
      console.log('Redis: Reconnecting...');
      isConnected = false;
    });

    await redisClient.connect();
    
    return redisClient;
  } catch (error) {
    console.error('Failed to initialize Redis:', error);
    // Don't throw - allow app to run without cache
    return null;
  }
}

/**
 * Get Redis client instance
 */
export function getRedisClient() {
  return redisClient;
}

/**
 * Check if Redis is connected
 */
export function isRedisConnected() {
  return isConnected && redisClient && redisClient.isOpen;
}

/**
 * Close Redis connection gracefully
 */
export async function closeRedis() {
  if (redisClient) {
    try {
      await redisClient.quit();
      console.log('Redis: Connection closed');
    } catch (error) {
      console.error('Error closing Redis connection:', error);
    }
  }
}

/**
 * Health check for Redis
 */
export async function redisHealthCheck() {
  if (!isRedisConnected()) {
    return { status: 'disconnected', message: 'Redis is not connected' };
  }

  try {
    await redisClient.ping();
    return { status: 'healthy', message: 'Redis is operational' };
  } catch (error) {
    return { status: 'unhealthy', message: error.message };
  }
}

