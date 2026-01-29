// ============================================================
//        TEXT TRANSFORMATION CONTROLLER
// ============================================================
//
// Elite AI-powered text transformation engine.
// The backend that powers the viral Select Text → AI Actions feature.
//
// ============================================================

const { OpenAI } = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Elite AI prompts for each transformation type
const TRANSFORMATION_PROMPTS = {
  rewrite: `You are an elite writing assistant. Rewrite the given text to be clearer, more engaging, and better structured while preserving the original meaning and tone. Make it flow naturally and be more compelling to read.

Rules:
- Preserve the original meaning and intent
- Improve clarity and readability
- Make it more engaging and compelling
- Maintain the appropriate tone
- Return ONLY the rewritten text, no explanations`,

  expand: `You are an expert content developer. Expand the given text by adding relevant details, examples, explanations, and context. Make it more comprehensive and informative while maintaining the original style and purpose.

Rules:
- Add valuable details and context
- Include relevant examples where appropriate
- Maintain the original style and tone
- Make it more comprehensive but not verbose
- Return ONLY the expanded text, no explanations`,

  shorten: `You are a master editor. Condense the given text to its essential points while preserving all key information and maintaining clarity. Remove redundancy and make every word count.

Rules:
- Preserve all key information
- Remove redundancy and filler words
- Maintain clarity and readability
- Keep the essential message intact
- Return ONLY the shortened text, no explanations`,

  makeProfessional: `You are a business communication expert. Transform the given text into professional, formal language suitable for business contexts. Use sophisticated vocabulary, proper structure, and maintain authority while being clear and respectful.

Rules:
- Use formal, professional language
- Maintain clarity and respect
- Use sophisticated but accessible vocabulary
- Structure for business contexts
- Return ONLY the professional version, no explanations`,

  makeCasual: `You are a conversational writing expert. Transform the given text into casual, friendly language that feels natural and approachable. Use conversational tone, contractions, and relatable expressions while keeping the core message intact.

Rules:
- Use casual, friendly language
- Include contractions and conversational phrases
- Make it feel natural and approachable
- Preserve the core message
- Return ONLY the casual version, no explanations`,

  fixGrammar: `You are an elite grammar and style expert. Correct all grammatical errors, improve sentence structure, fix punctuation, and enhance readability while preserving the original voice and meaning.

Rules:
- Fix all grammatical errors
- Improve sentence structure and flow
- Correct punctuation and spelling
- Preserve the original voice and meaning
- Return ONLY the corrected text, no explanations`,

  makeCreative: `You are a creative writing genius. Transform the given text to be more imaginative, engaging, and memorable. Use vivid language, interesting metaphors, and creative expressions while maintaining the core message.

Rules:
- Use vivid, imaginative language
- Add creative metaphors and expressions
- Make it more engaging and memorable
- Preserve the core message and meaning
- Return ONLY the creative version, no explanations`,

  makePersuasive: `You are a master of persuasion. Transform the given text to be more compelling and convincing. Use persuasive techniques, stronger language, and emotional appeals while maintaining credibility and authenticity.

Rules:
- Use persuasive language and techniques
- Make it more compelling and convincing
- Include emotional appeals where appropriate
- Maintain credibility and authenticity
- Return ONLY the persuasive version, no explanations`,

  summarize: `You are an expert summarizer. Create a concise, well-structured summary that captures all the key points and essential information from the given text. Make it clear and easy to understand.

Rules:
- Capture all key points and essential information
- Make it concise but comprehensive
- Structure it clearly and logically
- Ensure it's easy to understand
- Return ONLY the summary, no explanations`,

  translate: `You are a professional translator. Translate the given text to the target language while preserving the meaning, tone, and style as much as possible.

Rules:
- Preserve meaning, tone, and style
- Use natural language in the target language
- Maintain cultural appropriateness
- Ensure accuracy and fluency
- Return ONLY the translated text, no explanations`
};

// Transform text using AI
const transformText = async (req, res) => {
  try {
    const { text, action, context, targetLanguage } = req.body;

    // Validate input
    if (!text || !action) {
      return res.status(400).json({
        error: 'Text and action are required',
        code: 'MISSING_PARAMETERS'
      });
    }

    if (text.trim().length === 0) {
      return res.status(400).json({
        error: 'Text cannot be empty',
        code: 'EMPTY_TEXT'
      });
    }

    if (text.length > 10000) {
      return res.status(400).json({
        error: 'Text is too long (max 10,000 characters)',
        code: 'TEXT_TOO_LONG'
      });
    }

    // Get the appropriate prompt
    const systemPrompt = TRANSFORMATION_PROMPTS[action];
    if (!systemPrompt) {
      return res.status(400).json({
        error: 'Invalid action type',
        code: 'INVALID_ACTION'
      });
    }

    // Build the user message
    let userMessage = `Text to transform: "${text}"`;
    
    // Add context if provided
    if (context && context.trim().length > 0) {
      userMessage += `\n\nDocument context: "${context.trim()}"`;
    }

    // Add target language for translation
    if (action === 'translate' && targetLanguage) {
      userMessage += `\n\nTarget language: ${targetLanguage}`;
    }

    console.log(`🤖 Transforming text with action: ${action}`);
    console.log(`📝 Text length: ${text.length} characters`);

    // Call OpenAI API
    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: systemPrompt
        },
        {
          role: 'user',
          content: userMessage
        }
      ],
      temperature: action === 'fixGrammar' ? 0.1 : 0.3,
      max_tokens: Math.min(4000, text.length * 3),
      presence_penalty: 0.1,
      frequency_penalty: 0.1,
    });

    const transformedText = completion.choices[0].message.content.trim();

    if (!transformedText || transformedText.length === 0) {
      throw new Error('AI returned empty response');
    }

    console.log(`✅ Transformation successful: ${transformedText.length} characters`);

    // Return the transformed text
    res.json({
      transformedText,
      originalText: text,
      action,
      processingTime: Date.now() - req.startTime,
      success: true
    });

  } catch (error) {
    console.error('❌ Text transformation error:', error);

    // Handle specific OpenAI errors
    if (error.code === 'insufficient_quota') {
      return res.status(429).json({
        error: 'AI service temporarily unavailable',
        code: 'QUOTA_EXCEEDED'
      });
    }

    if (error.code === 'rate_limit_exceeded') {
      return res.status(429).json({
        error: 'Too many requests, please try again later',
        code: 'RATE_LIMITED'
      });
    }

    // Generic error response
    res.status(500).json({
      error: 'Text transformation failed',
      code: 'TRANSFORMATION_ERROR',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

// Translate text to target language
const translateText = async (req, res) => {
  try {
    const { text, targetLanguage } = req.body;

    if (!text || !targetLanguage) {
      return res.status(400).json({
        error: 'Text and target language are required',
        code: 'MISSING_PARAMETERS'
      });
    }

    console.log(`🌍 Translating to: ${targetLanguage}`);

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: TRANSFORMATION_PROMPTS.translate
        },
        {
          role: 'user',
          content: `Translate this text to ${targetLanguage}: "${text}"`
        }
      ],
      temperature: 0.1,
      max_tokens: Math.min(4000, text.length * 2),
    });

    const translatedText = completion.choices[0].message.content.trim();

    console.log(`✅ Translation successful`);

    res.json({
      translatedText,
      originalText: text,
      targetLanguage,
      success: true
    });

  } catch (error) {
    console.error('❌ Translation error:', error);
    res.status(500).json({
      error: 'Translation failed',
      code: 'TRANSLATION_ERROR'
    });
  }
};

// Get available languages
const getLanguages = async (req, res) => {
  const languages = [
    { code: 'es', name: 'Spanish' },
    { code: 'fr', name: 'French' },
    { code: 'de', name: 'German' },
    { code: 'it', name: 'Italian' },
    { code: 'pt', name: 'Portuguese' },
    { code: 'ru', name: 'Russian' },
    { code: 'ja', name: 'Japanese' },
    { code: 'ko', name: 'Korean' },
    { code: 'zh', name: 'Chinese (Simplified)' },
    { code: 'ar', name: 'Arabic' },
    { code: 'hi', name: 'Hindi' },
    { code: 'nl', name: 'Dutch' },
    { code: 'sv', name: 'Swedish' },
    { code: 'no', name: 'Norwegian' },
    { code: 'da', name: 'Danish' },
    { code: 'pl', name: 'Polish' },
    { code: 'tr', name: 'Turkish' },
    { code: 'he', name: 'Hebrew' },
    { code: 'th', name: 'Thai' },
    { code: 'vi', name: 'Vietnamese' },
  ];

  res.json(languages);
};

module.exports = {
  transformText,
  translateText,
  getLanguages,
};