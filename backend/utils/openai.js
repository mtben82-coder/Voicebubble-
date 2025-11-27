import axios from 'axios';
import FormData from 'form-data';

const OPENAI_API_URL = 'https://api.openai.com/v1';

/**
 * Get OpenAI API key from environment
 */
function getApiKey() {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    throw new Error('OPENAI_API_KEY environment variable is not set');
  }
  return apiKey;
}

/**
 * Create axios instance for OpenAI API
 */
function createOpenAIClient() {
  return axios.create({
    baseURL: OPENAI_API_URL,
    headers: {
      'Authorization': `Bearer ${getApiKey()}`,
      'Content-Type': 'application/json'
    },
    timeout: 60000 // 60 seconds
  });
}

/**
 * Transcribe audio using Whisper API
 * @param {Buffer} audioBuffer - Audio file buffer
 * @param {string} filename - Original filename
 * @returns {Promise<string>} Transcribed text
 */
export async function transcribeAudio(audioBuffer, filename = 'audio.wav') {
  try {
    const formData = new FormData();
    formData.append('file', audioBuffer, {
      filename: filename,
      contentType: 'audio/wav'
    });
    formData.append('model', 'whisper-1');
    formData.append('language', 'en');
    formData.append('response_format', 'json');

    const response = await axios.post(
      `${OPENAI_API_URL}/audio/transcriptions`,
      formData,
      {
        headers: {
          'Authorization': `Bearer ${getApiKey()}`,
          ...formData.getHeaders()
        },
        timeout: 60000,
        maxContentLength: Infinity,
        maxBodyLength: Infinity
      }
    );

    return response.data.text;
  } catch (error) {
    console.error('Whisper API Error:', error.response?.data || error.message);
    throw new Error(`Transcription failed: ${error.response?.data?.error?.message || error.message}`);
  }
}

/**
 * Rewrite text using GPT-4 mini (streaming)
 * @param {Array} messages - Messages array for chat completion
 * @param {Object} params - Additional parameters (temperature, max_tokens)
 * @param {Function} onChunk - Callback for each chunk
 * @returns {Promise<string>} Complete response text
 */
export async function rewriteTextStreaming(messages, params, onChunk) {
  try {
    const client = createOpenAIClient();
    
    const response = await client.post('/chat/completions', {
      model: 'gpt-4o-mini',
      messages: messages,
      temperature: params.temperature || 0.7,
      max_tokens: params.max_tokens || 500,
      stream: true
    }, {
      responseType: 'stream'
    });

    let fullText = '';

    return new Promise((resolve, reject) => {
      response.data.on('data', (chunk) => {
        const lines = chunk.toString().split('\n').filter(line => line.trim() !== '');
        
        for (const line of lines) {
          const message = line.replace(/^data: /, '');
          
          if (message === '[DONE]') {
            resolve(fullText);
            return;
          }

          try {
            const parsed = JSON.parse(message);
            const content = parsed.choices[0]?.delta?.content;
            
            if (content) {
              fullText += content;
              // Call the chunk callback
              if (onChunk) {
                onChunk(content);
              }
            }
          } catch (error) {
            // Skip parsing errors for incomplete chunks
            if (!message.startsWith('[DONE]')) {
              console.error('Error parsing chunk:', error);
            }
          }
        }
      });

      response.data.on('error', (error) => {
        console.error('Stream error:', error);
        reject(new Error(`Streaming failed: ${error.message}`));
      });

      response.data.on('end', () => {
        resolve(fullText);
      });
    });
  } catch (error) {
    console.error('GPT-4 mini API Error:', error.response?.data || error.message);
    throw new Error(`Rewrite failed: ${error.response?.data?.error?.message || error.message}`);
  }
}

/**
 * Rewrite text using GPT-4 mini (non-streaming)
 * @param {Array} messages - Messages array for chat completion
 * @param {Object} params - Additional parameters (temperature, max_tokens)
 * @returns {Promise<string>} Response text
 */
export async function rewriteText(messages, params) {
  try {
    const client = createOpenAIClient();
    
    const response = await client.post('/chat/completions', {
      model: 'gpt-4o-mini',
      messages: messages,
      temperature: params.temperature || 0.7,
      max_tokens: params.max_tokens || 500,
      stream: false
    });

    return response.data.choices[0].message.content.trim();
  } catch (error) {
    console.error('GPT-4 mini API Error:', error.response?.data || error.message);
    throw new Error(`Rewrite failed: ${error.response?.data?.error?.message || error.message}`);
  }
}

/**
 * Health check for OpenAI API
 * @returns {Promise<boolean>} API availability status
 */
export async function checkOpenAIHealth() {
  try {
    const client = createOpenAIClient();
    // Make a minimal API call to check connectivity
    await client.get('/models');
    return true;
  } catch (error) {
    console.error('OpenAI API health check failed:', error.message);
    return false;
  }
}

