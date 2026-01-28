// ============================================================
// SMART ACTIONS CONTROLLER
// Extracts actionable items from voice input
// ============================================================

import { OpenAI } from "openai";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const LANGUAGE_NAMES = {
  "en": "English", "es": "Spanish", "fr": "French", "de": "German",
  "it": "Italian", "pt": "Portuguese", "ru": "Russian", "ja": "Japanese",
  "ko": "Korean", "zh": "Chinese", "ar": "Arabic", "hi": "Hindi",
  "fa": "Farsi (Persian)", "tr": "Turkish", "vi": "Vietnamese",
  "nl": "Dutch", "pl": "Polish", "uk": "Ukrainian", "he": "Hebrew"
};

function getLanguageName(code) {
  return LANGUAGE_NAMES[code] || "English";
}

const SMART_ACTIONS_PROMPT = `You are a SMART ACTION EXTRACTION ENGINE.

Your job: Analyze voice input and extract ALL actionable items.

For each action, identify:

📅 CALENDAR EVENTS:
- Meeting, call, appointment, event with specific time
- Extract: title, date/time, duration, location, attendees
- Time keywords: "tomorrow", "next week", "Monday at 3pm", "in 2 hours"

✉️ EMAILS:
- "Email X", "send to Y", "write to Z"
- Extract: recipient, subject (inferred from context), body
- Maintain professional/casual tone based on context

✅ TASKS/TODOS:
- Action verbs: "need to", "have to", "must", "remember to"
- Extract: task, due date (if mentioned), priority
- Priority indicators: "urgent", "ASAP", "important", "when you can"

📝 NOTES:
- Information to remember, lists, ideas
- Shopping lists, checklists, reminders without time
- Extract: title, content, type (list/note/idea)

💬 MESSAGES:
- "Tell team", "post in Slack", "message on Discord"
- Extract: platform (if mentioned), recipient, content
- Adapt format to platform (Slack vs Discord vs WhatsApp)

CRITICAL RULES:
1. Extract EVERY actionable item (one input can have multiple actions)
2. Be smart about dates: "tomorrow" = actual tomorrow date
3. Infer missing info intelligently (subject line from email body)
4. Format professionally and clearly
5. Include ALL context needed for action

OUTPUT FORMAT:
Return ONLY valid JSON (no markdown, no explanation):
{
  "actions": [
    {
      "type": "calendar|email|todo|note|message",
      "title": "Short title",
      "description": "Full details (optional)",
      "datetime": "ISO 8601 datetime (if applicable)",
      "location": "Place (if applicable)",
      "attendees": ["person1", "person2"] (if applicable),
      "recipient": "email recipient (if applicable)",
      "subject": "email subject (if applicable)",
      "body": "email/message body (if applicable)",
      "priority": "high|normal|low (if applicable)",
      "platform": "Slack|Discord|WhatsApp|etc (if mentioned)",
      "formatted": "Beautifully formatted text ready for export"
    }
  ]
}`;

export async function extractSmartActions(req, res) {
  try {
    const { text, language = "auto" } = req.body;

    if (!text) {
      return res.status(400).json({ error: "Text is required" });
    }

    const languageName = getLanguageName(language);
    const languageInstruction = language && language !== "auto"
      ? `\n\n🌍 OUTPUT LANGUAGE: ${languageName}\nAll formatted text must be in ${languageName}.`
      : "";

    const messages = [
      {
        role: "system",
        content: SMART_ACTIONS_PROMPT + languageInstruction
      },
      {
        role: "user",
        content: text
      }
    ];

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: messages,
      temperature: 0.3, // Lower temperature for more consistent extraction
      max_tokens: 1500,
    });

    const responseText = completion.choices[0].message.content.trim();
    
    // Parse JSON response
    let parsed;
    try {
      // Remove markdown code blocks if present
      const cleaned = responseText
        .replace(/```json\n?/g, '')
        .replace(/```\n?/g, '')
        .trim();
      parsed = JSON.parse(cleaned);
    } catch (parseError) {
      console.error("Failed to parse AI response:", responseText);
      throw new Error("AI returned invalid JSON");
    }

    // Validate and clean response
    if (!parsed.actions || !Array.isArray(parsed.actions)) {
      throw new Error("Invalid response structure");
    }

    // Ensure all actions have required fields
    const validActions = parsed.actions.filter(action => 
      action.type && action.title && action.formatted
    );

    res.json({
      actions: validActions,
      original_text: text
    });

  } catch (error) {
    console.error("Smart actions extraction error:", error);
    res.status(500).json({ 
      error: "Failed to extract smart actions",
      details: error.message 
    });
  }
}
