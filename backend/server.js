import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { initRedis, closeRedis, redisHealthCheck } from './config/redis.js';
import { getCacheStats } from './utils/cache.js';
import { checkOpenAIHealth } from './utils/openai.js';
import transcribeRouter from './routes/transcribe.js';
import rewriteRouter from './routes/rewrite.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// ===== MIDDLEWARE CONFIGURATION =====

// Security headers
app.use(helmet({
  contentSecurityPolicy: false, // Allow SSE
  crossOriginEmbedderPolicy: false
}));

// CORS configuration
app.use(cors({
  origin: NODE_ENV === 'production' 
    ? [
        'https://voicebubble.app', 
        'https://www.voicebubble.app',
        /\.railway\.app$/
      ]
    : '*', // Allow all origins in development
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Compression middleware
app.use(compression({
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  },
  level: 6 // Balanced compression level
}));

// Body parsers
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX) || 100, // Limit each IP to 100 requests per window
  message: {
    error: 'Too many requests',
    message: 'Please try again later'
  },
  standardHeaders: true,
  legacyHeaders: false,
  // Skip rate limiting for health checks
  skip: (req) => req.path === '/health'
});

app.use('/api/', limiter);

// Request logging middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${res.statusCode} (${duration}ms)`);
  });
  
  next();
});

// ===== ROUTES =====

// Health check endpoint
app.get('/health', async (req, res) => {
  const redisHealth = await redisHealthCheck();
  const openaiHealthy = await checkOpenAIHealth();
  
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    environment: NODE_ENV,
    services: {
      redis: redisHealth,
      openai: {
        status: openaiHealthy ? 'healthy' : 'unhealthy',
        configured: !!process.env.OPENAI_API_KEY
      }
    }
  };

  const allHealthy = redisHealth.status === 'healthy' && openaiHealthy;
  const statusCode = allHealthy ? 200 : 503;

  res.status(statusCode).json(health);
});

// Stats endpoint (useful for monitoring)
app.get('/stats', async (req, res) => {
  try {
    const cacheStats = await getCacheStats();
    
    res.json({
      uptime_seconds: process.uptime(),
      memory_usage: process.memoryUsage(),
      node_version: process.version,
      cache: cacheStats,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      error: 'Failed to get stats',
      message: error.message
    });
  }
});

// API Routes
app.use('/api/transcribe', transcribeRouter);
app.use('/api/rewrite', rewriteRouter);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    name: 'VoiceBubble API',
    version: '1.0.0',
    description: 'High-performance backend for voice transcription and text rewriting',
    endpoints: {
      health: '/health',
      stats: '/stats',
      transcribe: 'POST /api/transcribe',
      rewrite: 'POST /api/rewrite (SSE streaming)',
      rewrite_batch: 'POST /api/rewrite/batch'
    },
    documentation: 'https://github.com/yourusername/voicebubble'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    message: `Route ${req.method} ${req.path} not found`,
    available_endpoints: ['/', '/health', '/stats', '/api/transcribe', '/api/rewrite']
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  
  res.status(err.status || 500).json({
    error: err.name || 'Internal server error',
    message: err.message || 'An unexpected error occurred',
    ...(NODE_ENV === 'development' && { stack: err.stack })
  });
});

// ===== SERVER INITIALIZATION =====

let server;

async function startServer() {
  try {
    // Initialize Redis
    console.log('Initializing Redis...');
    await initRedis();
    console.log('Redis initialized');

    // Verify OpenAI API key
    if (!process.env.OPENAI_API_KEY) {
      console.warn('WARNING: OPENAI_API_KEY not set. API calls will fail.');
    } else {
      console.log('OpenAI API key configured');
    }

    // Start Express server
    server = app.listen(PORT, '0.0.0.0', () => {
      console.log('');
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log(`🚀 VoiceBubble Backend Server Running`);
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log(`📍 Environment: ${NODE_ENV}`);
      console.log(`🌐 Port: ${PORT}`);
      console.log(`🔗 URL: http://localhost:${PORT}`);
      console.log(`💚 Health: http://localhost:${PORT}/health`);
      console.log(`📊 Stats: http://localhost:${PORT}/stats`);
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('');
    });

    // Keep-alive settings
    server.keepAliveTimeout = 65000; // 65 seconds (longer than typical load balancer timeout)
    server.headersTimeout = 66000; // Slightly longer than keepAliveTimeout

  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
async function gracefulShutdown(signal) {
  console.log(`\n${signal} received. Starting graceful shutdown...`);
  
  // Stop accepting new connections
  if (server) {
    server.close(() => {
      console.log('HTTP server closed');
    });
  }

  // Close Redis connection
  await closeRedis();

  console.log('Graceful shutdown complete');
  process.exit(0);
}

// Handle shutdown signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught errors
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  gracefulShutdown('uncaughtException');
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Start the server
startServer();

export default app;

