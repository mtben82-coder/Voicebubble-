import express from 'express';
import multer from 'multer';
import { transcribeAudio } from '../utils/openai.js';
import { getCachedTranscription, cacheTranscription } from '../utils/cache.js';

const router = express.Router();

// Configure multer for file upload (memory storage)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 25 * 1024 * 1024, // 25MB limit (OpenAI's Whisper limit)
  },
  fileFilter: (req, file, cb) => {
    // Accept audio files
    const allowedMimes = [
      'audio/wav',
      'audio/wave',
      'audio/x-wav',
      'audio/mpeg',
      'audio/mp3',
      'audio/mp4',
      'audio/m4a',
      'audio/x-m4a',
      'audio/webm',
      'audio/ogg',
      'audio/flac'
    ];
    
    if (allowedMimes.includes(file.mimetype) || file.originalname.match(/\.(wav|mp3|m4a|webm|ogg|flac)$/i)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Please upload an audio file.'));
    }
  }
});

/**
 * POST /api/transcribe
 * Transcribe audio file using Whisper API with caching
 * 
 * Request: multipart/form-data with 'audio' file field
 * Response: { text: "transcribed text" }
 */
router.post('/', upload.single('audio'), async (req, res) => {
  const startTime = Date.now();
  
  try {
    // Validate file upload
    if (!req.file) {
      return res.status(400).json({
        error: 'No audio file provided',
        message: 'Please upload an audio file in the "audio" field'
      });
    }

    const audioBuffer = req.file.buffer;
    const filename = req.file.originalname || 'audio.wav';

    console.log(`Transcription request: ${filename} (${(audioBuffer.length / 1024).toFixed(2)} KB)`);

    // Check cache first
    const cachedResult = await getCachedTranscription(audioBuffer);
    
    if (cachedResult) {
      const duration = Date.now() - startTime;
      console.log(`Transcription served from cache in ${duration}ms`);
      
      return res.json({
        text: cachedResult,
        cached: true,
        duration_ms: duration
      });
    }

    // Transcribe using Whisper API
    const transcription = await transcribeAudio(audioBuffer, filename);

    // Cache the result
    await cacheTranscription(audioBuffer, transcription);

    const duration = Date.now() - startTime;
    console.log(`Transcription completed in ${duration}ms`);

    res.json({
      text: transcription,
      cached: false,
      duration_ms: duration
    });

  } catch (error) {
    console.error('Transcription error:', error);
    
    const duration = Date.now() - startTime;
    
    res.status(500).json({
      error: 'Transcription failed',
      message: error.message,
      duration_ms: duration
    });
  }
});

/**
 * Error handler for multer
 */
router.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        error: 'File too large',
        message: 'Audio file must be smaller than 25MB'
      });
    }
    return res.status(400).json({
      error: 'Upload error',
      message: error.message
    });
  }
  
  if (error) {
    return res.status(400).json({
      error: 'Invalid request',
      message: error.message
    });
  }
  
  next();
});

export default router;

