// ============================================================
//        VOICEBUBBLE PRESETS — RAW & UNFILTERED
// ============================================================

export const PRESET_DEFINITIONS = {

  // 1️⃣ MAGIC
  "magic": {
    label: "Magic",
    temperature: 0.85,
    max_tokens: 650,
    behaviour: `You pick the best format and make it hit HARD. No fluff.`,
    examples: [
      {
        input: "tell the team about the deadline",
        output: "Team update:\n\nDeadline's Thursday. Here's what needs done:\n- Finish your tasks\n- Flag blockers\n- Update tracker\n\nLet me know if anything's stuck."
      }
    ]
  },

  // 2️⃣ EMAIL PRO
  "email_professional": {
    label: "Email – Professional",
    temperature: 0.55,
    max_tokens: 500,
    behaviour: `Professional. Confident. No bullshit.`,
    examples: [
      {
        input: "project delayed 2 weeks",
        output: "Hi team,\n\nQuick update: timeline extends two weeks due to resource constraints. Revised schedule coming tomorrow.\n\nBest,\n[Name]"
      }
    ]
  },

  // 3️⃣ EMAIL CASUAL  
  "email_casual": {
    label: "Email – Casual",
    temperature: 0.65,
    max_tokens: 500,
    behaviour: `Friendly but not cringe. Human.`,
    examples: [
      {
        input: "meeting moved thursday",
        output: "Hey,\n\nMeeting shifted to Thursday 3pm. Still work for you?\n\nCheers"
      }
    ]
  },

  // 4️⃣ QUICK REPLY
  "quick_reply": {
    label: "Quick Reply", 
    temperature: 0.8,
    max_tokens: 300,
    behaviour: `Match their energy. Be smooth. Never try-hard.`,
    examples: [
      {
        input: "she said: long day",
        output: "What drained you most?"
      }
    ]
  },

  // 5️⃣ DATING OPENER — PURE RIZZ
  "dating_opener": {
    label: "Dating – Opener",
    temperature: 0.88,
    max_tokens: 320,
    behaviour: `
MISSION: Make them WANT to respond.

RULE 1: If they give you bio/pics → BE SPECIFIC. Reference exact details.
RULE 2: If no context → Use curiosity/challenge pattern.
RULE 3: Keep it 1-2 sentences. Make it EASY to reply.

PATTERN:
"You look like [specific observation]. [Question or playful assumption]?"

NEVER:
- Generic shit ("hey beautiful")
- Interview mode
- Try-hard jokes
- Needy energy

ALWAYS:
- Specific to THEM
- Playful challenge
- Easy reply path
- Confident, not desperate
    `,
    examples: [
      {
        input: "she loves hiking and coffee",
        output: "You look like you know the best post-hike coffee spot but gatekeep it. Am I making the list or nah?"
      },
      {
        input: "has a dog, mentions travel",
        output: "Does the dog come on trips or judge you from home every time you leave?"
      },
      {
        input: "books, true crime, wine",
        output: "You give off 'reads true crime with wine and lowkey thinks I could solve a case' energy. How accurate?"
      },
      {
        input: "gym pic",
        output: "You look like you'd call my workout cute then destroy me. Should I be scared?"
      },
      {
        input: "foodie",
        output: "Hidden gems nobody knows or trendy spots everyone's at — which one's your move?"
      },
      {
        input: "works in tech, has cat",
        output: "So you code all day then get bossed around by a cat at night. What's the power dynamic like?"
      },
      {
        input: "music festivals",
        output: "You seem like you have Opinions on which festival has the best vibes. Go ahead, judge me."
      },
      {
        input: "beach pic with friends",
        output: "You planned the whole trip then acted like it just came together, didn't you?"
      },
      {
        input: "plants and iced coffee",
        output: "Do your plants have names and full personalities yet or are you in denial?"
      },
      {
        input: "plays guitar",
        output: "Three chords but you'll still make it emotional. What's the go-to song?"
      },
      {
        input: "travel pics",
        output: "How many of your stories start with 'so we got a little lost' and end in chaos?"
      },
      {
        input: "marketing, brunch",
        output: "You've ranked every brunch spot in your head. Top 3, go."
      },
      {
        input: "no info, generic opener",
        output: "You're either wildly spontaneous or you plan everything. Which one's the lie?"
      },
      {
        input: "art museums",
        output: "Modern art: genius or someone messing with us? I need your stance."
      },
      {
        input: "surfboard pic",
        output: "5am waves and still have energy after. What's the secret?"
      },
      {
        input: "loves cooking",
        output: "You follow the recipe once then freestyle. How many kitchen fires we talking?"
      },
      {
        input: "exploring cities",
        output: "You find the random spots everyone walks past. Best one you've found?"
      },
      {
        input: "healthcare, yoga",
        output: "So you save lives AND you're flexible. Most chaotic shift story, go."
      }
    ]
  },

  // 6️⃣ DATING REPLY — KEEP THE ENERGY
  "dating_reply": {
    label: "Dating – Reply",
    temperature: 0.88,
    max_tokens: 320,
    behaviour: `
MISSION: Build chemistry. Keep tension. Make them reply again.

FORMULA: Light tease + question OR validation + challenge

NEVER be:
- Needy
- Boring  
- Interview-mode
- Over-invested

ALWAYS be:
- Playful
- Slightly challenging
- Easy to respond to
- Confident
    `,
    examples: [
      {
        input: "she said: you're funny",
        output: "Careful. Keep gassing me up and I'll believe it. Most unserious thing you've laughed at lately?"
      },
      {
        input: "she said: dog person",
        output: "Respect. Dogs have better energy anyway. What chaos does yours cause?"
      },
      {
        input: "she said: love travelling",
        output: "Plan-every-detail or figure-it-out-when-you-land? This matters."
      },
      {
        input: "she said: competitive",
        output: "Yeah I already knew. Dumbest thing you've turned into a competition?"
      },
      {
        input: "she said: that's accurate",
        output: "I'm good at reading people. Should I keep going or are you scared of being fully called out?"
      },
      {
        input: "she said: maybe",
        output: "Maybe is just 'yes but not giving you the satisfaction.' I see you."
      },
      {
        input: "she said: you seem interesting",
        output: "Sounds like you're still deciding. What's the verdict?"
      },
      {
        input: "she said: hate small talk",
        output: "Same. Small talk's a war crime. One thing you believe that most people would fight you on?"
      },
      {
        input: "she said: omg yes",
        output: "Told you. Next test: pineapple on pizza. Defend your stance."
      },
      {
        input: "she said: work too much",
        output: "You're either building something big or terrible at saying no. Which one?"
      },
      {
        input: "she said: you're bold",
        output: "Life's too short. Someone's gotta risk actual conversation."
      },
      {
        input: "she said: sarcastic",
        output: "Perfect. I speak fluent sarcasm. Can you keep up?"
      },
      {
        input: "she said: shy at first",
        output: "I'm getting that. What gets you out of your shell?"
      },
      {
        input: "she said: good question",
        output: "I know. I don't do boring questions. You gonna answer or stall?"
      },
      {
        input: "she said: like your energy",
        output: "Dangerous. Keep talking like that and I might take you seriously."
      },
      {
        input: "she said: into fitness",
        output: "You'd destroy me at the gym. Supportive or roasting me the whole time?"
      },
      {
        input: "she said: don't know yet",
        output: "Fair. What usually helps you figure people out?"
      },
      {
        input: "she said: where you from",
        output: "Nice try but we're not doing interviews. Tell me something interesting first."
      },
      {
        input: "she said: you're different",
        output: "Taking that as good. Most people here read from the same script."
      }
    ]
  },

  // 7️⃣ SOCIAL VIRAL CAPTION
  "social_viral_caption": {
    label: "Social – Viral Caption",
    temperature: 0.90,
    max_tokens: 500,
    behaviour: `
MAKE IT STOP THE SCROLL.

LINE 1: Hook (bold/contrarian/relatable)
LINES 2-5: Build tension/story/contrast  
FINAL: Payoff + insight

RULES:
- Short sentences (8 words max)
- Line breaks for pacing
- Speak to ONE person
- Make it quotable
- Make them FEEL something

NO:
- Bland motivation
- Paragraphs
- Corporate speak
- Try-hard
    `,
    examples: [
      {
        input: "feeling stuck",
        output: "You're not stuck.\nYour perspective is.\n\nStuck people don't look for answers.\nYou're here.\nThat's proof you're moving.\n\nShift happens when you stop waiting for motivation.\nStart moving anyway.\n\nSmall. Ugly. Imperfect.\n\nThat's how you unstuck."
      },
      {
        input: "procrastination",
        output: "You're not procrastinating.\nYou're terrified of being seen trying.\n\nBecause if you never start, you never fail.\nSafe = stuck.\n\nThe moment failure becomes feedback?\nEverything opens.\n\nStart messy.\nFail fast.\nAdjust."
      },
      {
        input: "dating confidence",
        output: "Most attractive thing you can do?\n\nHave standards.\n\nNot rude.\n'I know my worth' energy.\n\nDesperation repels.\nStandards attract.\n\nStop chasing people who don't chase back."
      },
      {
        input: "social media comparison",
        output: "If scrolling makes you feel worse?\nDelete it.\n\nYou're not staying connected.\nYou're comparing your real life to highlight reels.\n\nLosing every time.\n\nYour mental health > 47 breakfast pics."
      },
      {
        input: "burnout",
        output: "You're not lazy.\nYou're burnt out.\n\nBig difference.\n\nLazy = don't care\nBurnt out = care so much you're exhausted\n\nFix isn't work harder.\nIt's work smarter + rest without guilt."
      },
      {
        input: "friendships ending",
        output: "Hardest pill:\n\nSome friendships expire.\n\nYou grew. They didn't.\nOr they grew. You didn't.\n\nForcing it hurts more than letting go.\n\nReal ones evolve with you.\nRest were lessons."
      },
      {
        input: "grind culture",
        output: "Stop romanticizing the grind.\n\n80 hours isn't a flex.\nIt's poor time management.\n\nReal success = results + rest.\n\nWork smart.\nProtect energy."
      },
      {
        input: "self improvement",
        output: "Most self-help is trash.\n\nWhat works:\n\n1. Sleep 7-8 hours\n2. Move daily\n3. Cut draining people\n4. Build one skill deep\n\nEverything else is noise."
      },
      {
        input: "content creation",
        output: "First 100 posts won't be perfect.\n\nThat's the point.\n\nYou're building reps.\nEvery post is data.\nEvery flop teaches.\n\nStop waiting.\nPost and learn."
      },
      {
        input: "relationships red flags",
        output: "If they wanted to, they would.\n\nStop making excuses for people who don't show up.\n\nBusy is myth.\nPriority is real.\n\nYou're either priority or option.\n\nKnow the difference."
      },
      {
        input: "confidence",
        output: "Confidence isn't 'I'm better than everyone.'\n\nIt's 'I'm okay with who I am.'\n\nYou stop caring what people think when you start liking who you see.\n\nThat's real confidence."
      },
      {
        input: "motivation vs discipline",
        output: "Motivation is garbage.\n\nShows up when it feels like it.\nDiscipline shows up daily.\n\nMotivation gets you started.\nDiscipline keeps you going.\n\nChoose discipline."
      },
      {
        input: "overthinking",
        output: "90% of what you worry about won't happen.\n\nThe 10% that does?\nYou'll handle it.\n\nOverthinking doesn't prevent bad things.\nIt ruins good moments.\n\nBreathe."
      },
      {
        input: "transformation",
        output: "You don't need new year.\nDon't need Monday.\nDon't need permission.\n\nYou need to decide.\nRight now.\n\nVersion of you that you want? Act like them today.\n\nThat's how transformation works."
      },
      {
        input: "toxic positivity",
        output: "Good vibes only is toxic.\n\nSometimes life sucks.\nPretending it doesn't makes it worse.\n\nYou're allowed to feel.\nSad. Angry. Lost.\n\nAll valid.\n\nHealing isn't forcing a smile.\nIt's sitting with hard stuff."
      }
    ]
  },

  // 8️⃣ SOCIAL VIRAL VIDEO
  "social_viral_video": {
    label: "Social – Viral Video",
    temperature: 0.90,
    max_tokens: 700,
    behaviour: `
MAKE THEM WATCH TILL THE END.

[0-3s] Hook - Stop scroll NOW
[3-8s] Setup - Create tension
[8-25s] Value - 3-5 punchy beats
[25-30s] Payoff - Aha moment
[30s+] CTA - Save/follow

Keep sentences under 8 words.
Time stamp everything.
    `,
    examples: [
      {
        input: "why goals fail",
        output: "[0-2s] HOOK\nIf your goals keep failing, it's not you.\n\n[2-6s] SETUP\nIt's how you're setting them.\n\n[6-22s] VALUE\nMost people: 'lose weight'\nThat's a wish.\n\nReal goal:\n- Lose 10 lbs\n- 8 weeks\n- Gym 4x/week\n\nVague goals = vague results.\n\n[22-28s] PAYOFF\nGet specific. Everything clicks.\n\n[28-30s] CTA\nSave if you needed this."
      },
      {
        input: "dating red flags",
        output: "[0-3s] HOOK\nRed flag if they do this.\nRUN.\n\n[3-6s] SETUP\nFirst date instant tells.\n\n[6-24s] VALUE\n1. Rude to waiter\n   Shows how they treat people\n\n2. Only talk about themselves\n   Zero questions = zero interest\n\n3. Trash their ex\n   Can't move on = you won't either\n\n[24-28s] PAYOFF\nTrust red flags. Never lying.\n\n[28-30s] CTA\nComment which you've seen."
      },
      {
        input: "phone destroying focus",
        output: "[0-3s] HOOK\nYour phone's destroying your brain.\n\n[3-7s] SETUP\nYou don't even realize.\n\n[7-25s] VALUE\nEvery notification = dopamine spike.\nBrain gets addicted.\n\nNormal tasks feel boring.\nBrain expects constant hits.\n\nFix:\n- Turn off ALL notifications\n- Phone in other room\n- 90-min deep work blocks\n\n[25-30s] PAYOFF\nFocus comes back. Give it 3 days.\n\n[30-33s] CTA\nTry it. Report back."
      },
      {
        input: "overthinking",
        output: "[0-2s] HOOK\nIf you overthink everything, listen.\n\n[2-6s] SETUP\nYour brain isn't broken.\nIt's bored.\n\n[6-24s] VALUE\nOverthinking when:\n- Too much time\n- Not enough action\n\nBrain fills gap with worst-case scenarios.\n\nCure isn't think less.\nIt's do more.\n\nMove body.\nBuild something.\nTalk to someone.\n\n[24-28s] PAYOFF\nAction kills anxiety every time.\n\n[28-30s] CTA\nSave if needed."
      },
      {
        input: "building confidence",
        output: "[0-3s] HOOK\nStop looking for confidence.\nBuild evidence.\n\n[3-7s] SETUP\nConfidence isn't feeling.\nIt's proof.\n\n[7-26s] VALUE\nNo confidence because zero evidence you can do hard things.\n\nStart:\n- Wake on time 7 days\n- Finish what you start\n- Keep one promise\n\nEvery win = evidence.\nEvidence = confidence.\n\n[26-30s] PAYOFF\nYou don't find it.\nYou build it.\n\n[30-32s] CTA\nFollow for more."
      },
      {
        input: "toxic people",
        output: "[0-3s] HOOK\nIf someone drains you?\nRemove them.\n\n[3-6s] SETUP\nDon't care who they are.\n\n[6-24s] VALUE\nYour energy is limited.\n\nToxic people don't get better.\nThey get comfortable.\n\nLonger you stay?\nMore they take.\n\nBoundaries aren't rude.\nThey're self-respect.\n\n[24-28s] PAYOFF\nProtect your peace.\n\n[28-30s] CTA\nTag someone who needs this."
      }
    ]
  },

  // 9️⃣ REWRITE / ENHANCE
  "rewrite_enhance": {
    label: "Rewrite / Enhance",
    temperature: 0.7,
    max_tokens: 650,
    behaviour: `Keep meaning. Upgrade everything else. Remove rambling.`,
    examples: [
      {
        input: "maybe we should try something else this isn't working",
        output: "We should explore a different approach — this isn't producing results."
      }
    ]
  },

  // 🔟 SHORTEN
  "shorten": {
    label: "Shorten",
    temperature: 0.35,
    max_tokens: 300,
    behaviour: `Cut 40-60%. Keep ALL meaning.`,
    examples: [
      {
        input: "sorry running late traffic is insane doing my best",
        output: "Running late — traffic's crazy. On my way."
      }
    ]
  },

  // 1️⃣1️⃣ EXPAND
  "expand": {
    label: "Expand",
    temperature: 0.75,
    max_tokens: 900,
    behaviour: `Add depth, emotion, context. Keep their tone.`,
    examples: [
      {
        input: "proud of myself today",
        output: "Actually proud of myself today. Pushed through resistance, stayed focused, proved I can do more than I give myself credit for."
      }
    ]
  },

  // 1️⃣2️⃣ FORMAL / BUSINESS
  "formal_business": {
    label: "Formal / Business",
    temperature: 0.45,
    max_tokens: 600,
    behaviour: `Professional. Concise. Zero fluff.`,
    examples: [
      {
        input: "need to fix the issue soon",
        output: "We need to resolve this promptly, as it's affecting other workflow areas."
      }
    ]
  }
};
