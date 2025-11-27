import crypto from 'crypto';
import { getRedisClient, isRedisConnected } from '../config/redis.js';

// Default TTL values (in seconds)
const DEFAULT_TRANSCRIPTION_TTL = parseInt(process.env.TRANSCRIPTION_CACHE_TTL) || 86400; // 24 hours
const DEFAULT_REWRITE_TTL = parseInt(process.env.REWRITE_CACHE_TTL) || 604800; // 7 days

/**
 * Generate cache key hash from content
 * @param {string} prefix - Cache key prefix (e.g., 'transcription', 'rewrite')
 * @param {string|Buffer} content - Content to hash
 * @returns {string} Cache key
 */
export function generateCacheKey(prefix, content) {
  const hash = crypto.createHash('sha256').update(content).digest('hex');
  return `${prefix}:${hash}`;
}

/**
 * Get cached value
 * @param {string} key - Cache key
 * @returns {Promise<string|null>} Cached value or null
 */
export async function getCached(key) {
  if (!isRedisConnected()) {
    console.log('Cache miss: Redis not connected');
    return null;
  }

  try {
    const client = getRedisClient();
    const value = await client.get(key);
    
    if (value) {
      console.log(`Cache hit: ${key}`);
      return value;
    } else {
      console.log(`Cache miss: ${key}`);
      return null;
    }
  } catch (error) {
    console.error('Error getting cached value:', error);
    return null;
  }
}

/**
 * Set cached value
 * @param {string} key - Cache key
 * @param {string} value - Value to cache
 * @param {number} ttl - Time to live in seconds
 * @returns {Promise<boolean>} Success status
 */
export async function setCached(key, value, ttl = DEFAULT_REWRITE_TTL) {
  if (!isRedisConnected()) {
    console.log('Skip cache: Redis not connected');
    return false;
  }

  try {
    const client = getRedisClient();
    await client.setEx(key, ttl, value);
    console.log(`Cache set: ${key} (TTL: ${ttl}s)`);
    return true;
  } catch (error) {
    console.error('Error setting cached value:', error);
    return false;
  }
}

/**
 * Get or set cached value (cache-aside pattern)
 * @param {string} key - Cache key
 * @param {Function} fetchFn - Async function to fetch value if not cached
 * @param {number} ttl - Time to live in seconds
 * @returns {Promise<any>} Cached or fetched value
 */
export async function getOrSet(key, fetchFn, ttl = DEFAULT_REWRITE_TTL) {
  // Try to get from cache
  const cached = await getCached(key);
  if (cached !== null) {
    return cached;
  }

  // Fetch fresh value
  const value = await fetchFn();

  // Store in cache
  await setCached(key, value, ttl);

  return value;
}

/**
 * Cache transcription result
 * @param {Buffer} audioBuffer - Audio file buffer
 * @param {string} transcription - Transcription text
 * @returns {Promise<boolean>} Success status
 */
export async function cacheTranscription(audioBuffer, transcription) {
  const key = generateCacheKey('transcription', audioBuffer);
  return await setCached(key, transcription, DEFAULT_TRANSCRIPTION_TTL);
}

/**
 * Get cached transcription
 * @param {Buffer} audioBuffer - Audio file buffer
 * @returns {Promise<string|null>} Cached transcription or null
 */
export async function getCachedTranscription(audioBuffer) {
  const key = generateCacheKey('transcription', audioBuffer);
  return await getCached(key);
}

/**
 * Cache rewrite result
 * @param {string} text - Input text
 * @param {string} presetId - Preset ID
 * @param {string} result - Rewrite result
 * @returns {Promise<boolean>} Success status
 */
export async function cacheRewrite(text, presetId, result) {
  const key = generateCacheKey('rewrite', `${presetId}:${text}`);
  return await setCached(key, result, DEFAULT_REWRITE_TTL);
}

/**
 * Get cached rewrite result
 * @param {string} text - Input text
 * @param {string} presetId - Preset ID
 * @returns {Promise<string|null>} Cached result or null
 */
export async function getCachedRewrite(text, presetId) {
  const key = generateCacheKey('rewrite', `${presetId}:${text}`);
  return await getCached(key);
}

/**
 * Delete cached value
 * @param {string} key - Cache key
 * @returns {Promise<boolean>} Success status
 */
export async function deleteCached(key) {
  if (!isRedisConnected()) {
    return false;
  }

  try {
    const client = getRedisClient();
    await client.del(key);
    console.log(`Cache deleted: ${key}`);
    return true;
  } catch (error) {
    console.error('Error deleting cached value:', error);
    return false;
  }
}

/**
 * Get cache statistics
 * @returns {Promise<object>} Cache stats
 */
export async function getCacheStats() {
  if (!isRedisConnected()) {
    return { connected: false };
  }

  try {
    const client = getRedisClient();
    const info = await client.info('stats');
    
    // Parse info string to extract useful stats
    const stats = {};
    info.split('\r\n').forEach(line => {
      const [key, value] = line.split(':');
      if (key && value) {
        stats[key] = value;
      }
    });

    return {
      connected: true,
      keyspace_hits: stats.keyspace_hits || 0,
      keyspace_misses: stats.keyspace_misses || 0,
      total_commands_processed: stats.total_commands_processed || 0
    };
  } catch (error) {
    console.error('Error getting cache stats:', error);
    return { connected: true, error: error.message };
  }
}

