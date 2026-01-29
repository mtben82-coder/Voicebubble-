// ============================================================
// SMART ACTIONS CONTROLLER - ULTRA STRICT VERSION
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

const SMART_ACTIONS_PROMPT = `You are a SMART ACTION DETECTOR. Be EXTREMELY CAREFUL about calendar events.

🚨 PRIORITY ORDER (check in this order):

1️⃣ EMAIL (check FIRST):
- "Dear [name]" → EMAIL
- "Hi [name]" → EMAIL  
- "yours sincerely" / "best regards" / "kind regards" / "cheers" / "thanks" → EMAIL
- Multiple paragraphs → EMAIL
- Professional tone → EMAIL
- "email to" / "send to" / "write to" → EMAIL
⚠️ IF ANY OF THESE = EMAIL (NOT calendar, NOT task)

2️⃣ TODO/TASK (check SECOND):
- "I need to" / "I have to" / "remember to" → TASK
- Action without specific time → TASK
- "call X" / "buy Y" / "finish Z" → TASK
- "sometime" / "later" / "this week" → TASK (no specific time)

3️⃣ CALENDAR (check LAST, needs ALL of these):
- ✅ Explicit time: "tomorrow at 3pm", "Monday at 2pm", "next Tuesday at 10am"
- ✅ Meeting/event context: "meeting with", "call with", "appointment with"
- ✅ Can calculate exact datetime
- ❌ If NO exact time → NOT calendar (it's a task)

4️⃣ NOTE:
- Just information to save
- Lists, ideas, thoughts

5️⃣ MESSAGE:
- "tell team" / "post in Slack"

🔥 CRITICAL RULES:
1. Email signature = EMAIL (NEVER calendar)
2. No specific time = NOT calendar (it's task)
3. "I need to meet John" (no time) = TASK (not calendar)
4. "Meeting with John tomorrow at 3pm" = CALENDAR (has time)
5. When in doubt between calendar and something else → choose the something else

❌ NEVER CREATE CALENDAR WITHOUT EXACT TIME:
- "call John next week" → TASK (no exact time)
- "meeting sometime" → TASK (no exact time)
- "call John tomorrow at 2pm" → CALENDAR (exact time)

OUTPUT JSON (no markdown):
{
  "actions": [
    {
      "type": "email|todo|calendar|note|message",
      "title": "Brief title",
      "description": "Details",
      "datetime": "ISO 8601 ONLY if type is calendar AND you have exact time",
      "recipient": "For email only",
      "subject": "For email only",
      "body": "Full body for email/message",
      "formattedText": "Ready-to-use text"
    }
  ]
}

EXAMPLES:

❌ WRONG:
Input: "Dear John, thanks for your time. Yours sincerely"
Output: calendar ← WRONG! Has email signature!
✅ CORRECT: email

❌ WRONG:
Input: "I need to call Sarah sometime next week"
Output: calendar ← WRONG! No exact time!
✅ CORRECT: todo

✅ CORRECT:
Input: "Meeting with Sarah tomorrow at 3pm"
Output: calendar with datetime ← CORRECT! Has exact time!

BE CONSERVATIVE. IF UNSURE → NOT CALENDAR.`;

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
      temperature: 0.05, // ULTRA low for consistency
      max_tokens: 2000,
    });

    const responseText = completion.choices[0].message.content.trim();
    
    // Parse JSON response
    let parsed;
    try {
      const cleaned = responseText
        .replace(/```json\n?/g, '')
        .replace(/```\n?/g, '')
        .trim();
      parsed = JSON.parse(cleaned);
    } catch (parseError) {
      console.error("❌ Failed to parse AI response:", responseText);
      throw new Error("AI returned invalid JSON");
    }

    // Validate structure
    if (!parsed.actions || !Array.isArray(parsed.actions)) {
      throw new Error("Invalid response structure");
    }

    // 🔥 ULTRA STRICT VALIDATION
    const validActions = parsed.actions.filter(action => {
      // Must have basics
      if (!action.type || !action.title || !action.formattedText) {
        console.warn(`⚠️ REJECTED: Missing required fields`);
        return false;
      }

      // 🔥 CALENDAR MUST HAVE DATETIME OR REJECTED
      if (action.type === 'calendar') {
        if (!action.datetime) {
          console.warn(`🚫 REJECTED CALENDAR: "${action.title}" - NO DATETIME`);
          return false;
        }
        // Validate datetime format
        try {
          new Date(action.datetime);
        } catch {
          console.warn(`🚫 REJECTED CALENDAR: "${action.title}" - INVALID DATETIME`);
          return false;
        }
      }

      // EMAIL must have body or recipient
      if (action.type === 'email' && !action.body && !action.recipient) {
        console.warn(`⚠️ REJECTED EMAIL: "${action.title}" - NO BODY/RECIPIENT`);
        return false;
      }

      return true;
    });

    // If no valid actions, return empty array (not error)
    if (validActions.length === 0) {
      console.log(`⚠️ No valid actions extracted from: "${text.substring(0, 50)}..."`);
      return res.json({
        actions: [],
        original_text: text,
        message: "No clear actionable items detected"
      });
    }

    // Log success
    console.log(`✅ Extracted ${validActions.length} valid actions:`);
    validActions.forEach(action => {
      console.log(`  - ${action.type.toUpperCase()}: ${action.title}`);
    });

    res.json({
      actions: validActions,
      original_text: text
    });

  } catch (error) {
    console.error("❌ Smart actions extraction error:", error);
    res.status(500).json({ 
      error: "Failed to extract smart actions",
      details: error.message 
    });
  }
}
