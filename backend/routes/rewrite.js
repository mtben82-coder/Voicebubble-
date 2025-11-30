import express from 'express';
import { rewriteTextStreaming } from '../utils/openai.js';
import { getCachedRewrite, cacheRewrite } from '../utils/cache.js';
import { buildMessages, getPresetParameters } from '../config/prompts.js';

const router = express.Router();

/**
 * POST /api/rewrite
 * Rewrite text using GPT-4 mini with streaming and caching
 * 
 * Request body: { text: "input text", presetId: "magic" }
 * Response: Server-Sent Events (SSE) stream
 * 
 * Events:
 * - data: text chunks
 * - done: complete result with metadata
 * - error: error message
 */
router.post('/', async (req, res) => {
  const startTime = Date.now();
  
  try {
    // Validate request body
    const { text, presetId } = req.body;

    if (!text || typeof text !== 'string') {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Text is required and must be a string'
      });
    }

    if (!presetId || typeof presetId !== 'string') {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Preset ID is required and must be a string'
      });
    }

    console.log(`Rewrite request: preset=${presetId}, length=${text.length}`);

    // Check cache first
    const cachedResult = await getCachedRewrite(text, presetId);
    
    if (cachedResult) {
      const duration = Date.now() - startTime;
      console.log(`Rewrite served from cache in ${duration}ms`);
      
      // Set headers for SSE
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      
      // Send cached result as a complete stream
      res.write(`data: ${JSON.stringify({ chunk: cachedResult, cached: true })}\n\n`);
      res.write(`data: ${JSON.stringify({ 
        type: 'done', 
        text: cachedResult, 
        cached: true,
        duration_ms: duration 
      })}\n\n`);
      res.end();
      return;
    }

    // Set headers for SSE
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    // Build messages with few-shot examples
    const messages = buildMessages(presetId, text);
    const params = getPresetParameters(presetId);

    let fullText = '';

    // Stream response
    const result = await rewriteTextStreaming(messages, params, (chunk) => {
      fullText += chunk;
      // Send chunk to client
      res.write(`data: ${JSON.stringify({ chunk })}\n\n`);
    });

    // Cache the complete result
    await cacheRewrite(text, presetId, result);

    const duration = Date.now() - startTime;
    console.log(`Rewrite completed in ${duration}ms`);

    // Send completion event
    res.write(`data: ${JSON.stringify({ 
      type: 'done', 
      text: result, 
      cached: false,
      duration_ms: duration 
    })}\n\n`);
    res.end();

  } catch (error) {
    console.error('Rewrite error:', error);
    
    const duration = Date.now() - startTime;
    
    // Send error event
    res.write(`data: ${JSON.stringify({ 
      type: 'error', 
      error: 'Rewrite failed',
      message: error.message,
      duration_ms: duration 
    })}\n\n`);
    res.end();
  }
});

/**
 * POST /api/rewrite/batch
 * Non-streaming endpoint for simple batch requests
 * 
 * Request body: { text: "input text", presetId: "magic" }
 * Response: { text: "rewritten text", cached: boolean, duration_ms: number }
 */
router.post('/batch', async (req, res) => {
  const startTime = Date.now();
  
  try {
    const { text, presetId, language } = req.body;

    if (!text || typeof text !== 'string') {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Text is required and must be a string'
      });
    }

    if (!presetId || typeof presetId !== 'string') {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Preset ID is required and must be a string'
      });
    }

    const outputLanguage = language || 'en'; // Default to English if not specified
    console.log(`Batch rewrite request: preset=${presetId}, language=${outputLanguage}, length=${text.length}`);

    // Check cache (include language in cache key)
    const cacheKey = `${text}_${presetId}_${outputLanguage}`;
    const cachedResult = await getCachedRewrite(cacheKey, presetId);
    
    if (cachedResult) {
      const duration = Date.now() - startTime;
      console.log(`Batch rewrite served from cache in ${duration}ms`);
      
      return res.json({
        text: cachedResult,
        cached: true,
        duration_ms: duration
      });
    }

    // Build messages and rewrite with language preference
    const messages = buildMessages(presetId, text, outputLanguage);
    const params = getPresetParameters(presetId);

    let fullText = '';
    const result = await rewriteTextStreaming(messages, params, (chunk) => {
      fullText += chunk;
    });

    // Cache result (include language in cache key)
    await cacheRewrite(cacheKey, presetId, result);

    const duration = Date.now() - startTime;
    console.log(`Batch rewrite completed in ${duration}ms`);

    res.json({
      text: result,
      cached: false,
      duration_ms: duration
    });

  } catch (error) {
    console.error('Batch rewrite error:', error);
    
    const duration = Date.now() - startTime;
    
    res.status(500).json({
      error: 'Rewrite failed',
      message: error.message,
      duration_ms: duration
    });
  }
});

export default router;

