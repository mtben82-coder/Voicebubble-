import '../models/template.dart';

class BuiltInTemplates {
  // PRODUCTIVITY TEMPLATES
  static const Template meetingNotes = Template(
    id: 'meeting_notes',
    name: 'Meeting Notes',
    description: 'Capture meeting details, decisions, and action items',
    category: TemplateCategory.productivity,
    icon: '📝',
    content: '''# Meeting Notes

**Date:** [Date]
**Attendees:** [Names]
**Agenda:** [Topic]

## Key Points
- 

## Decisions Made
- 

## Action Items
- [ ] 
- [ ] 

## Next Steps
''',
    backgroundId: 'color_sky',
  );

  static const Template dailyJournal = Template(
    id: 'daily_journal',
    name: 'Daily Journal',
    description: 'Reflect on your day and plan tomorrow',
    category: TemplateCategory.personal,
    icon: '📔',
    content: '''# Daily Journal - [Date]

## Today's Highlights
- 

## Grateful For
1. 
2. 
3. 

## Challenges Faced
- 

## Tomorrow's Focus
- 
- 
- 

## Mood: 😊
''',
    backgroundId: 'gradient_peach',
  );

  static const Template projectPlan = Template(
    id: 'project_plan',
    name: 'Project Plan',
    description: 'Plan and organize project milestones',
    category: TemplateCategory.productivity,
    icon: '📊',
    content: '''# Project Plan: [Project Name]

## Overview
[Brief description]

## Goals
- 
- 

## Timeline
- **Phase 1:** [Start - End]
- **Phase 2:** [Start - End]
- **Phase 3:** [Start - End]

## Resources Needed
- 
- 

## Success Metrics
- 
- 

## Risks & Mitigation
- 
''',
    backgroundId: 'color_blue',
  );

  static const Template weeklyReview = Template(
    id: 'weekly_review',
    name: 'Weekly Review',
    description: 'Reflect on the week and plan ahead',
    category: TemplateCategory.productivity,
    icon: '📅',
    content: '''# Weekly Review - Week of [Date]

## Wins This Week
- 
- 
- 

## Lessons Learned
- 

## Goals Achieved
- [ ] 
- [ ] 

## Next Week's Priorities
1. 
2. 
3. 

## Areas to Improve
- 
''',
    backgroundId: 'gradient_lavender',
  );

  static const Template groceryList = Template(
    id: 'grocery_list',
    name: 'Grocery List',
    description: 'Organize your shopping needs',
    category: TemplateCategory.personal,
    icon: '🛒',
    content: '''# Grocery List

## Produce
- [ ] 
- [ ] 

## Dairy & Eggs
- [ ] 
- [ ] 

## Meat & Protein
- [ ] 
- [ ] 

## Pantry Staples
- [ ] 
- [ ] 

## Snacks & Beverages
- [ ] 
- [ ] 

## Other
- [ ] 
''',
    backgroundId: 'color_mint',
  );

  static const Template workoutLog = Template(
    id: 'workout_log',
    name: 'Workout Log',
    description: 'Track your fitness routine',
    category: TemplateCategory.health,
    icon: '💪',
    content: '''# Workout Log - [Date]

## Today's Focus: [Muscle Group/Cardio]

### Warm-up (10 min)
- 

### Main Workout
**Exercise 1:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

**Exercise 2:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

**Exercise 3:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

### Cool Down
- 

## Notes
- Energy Level: /10
- Form Check: 
''',
    backgroundId: 'gradient_neon',
  );

  static const Template recipeTemplate = Template(
    id: 'recipe',
    name: 'Recipe',
    description: 'Save your favorite recipes',
    category: TemplateCategory.personal,
    icon: '🍳',
    content: '''# [Recipe Name]

**Prep Time:** [X minutes]
**Cook Time:** [X minutes]
**Servings:** [X]

## Ingredients
- 
- 
- 

## Instructions
1. 
2. 
3. 
4. 

## Tips & Notes
- 

## Rating: ⭐⭐⭐⭐⭐
''',
    backgroundId: 'color_peach',
  );

  static const Template travelPlanner = Template(
    id: 'travel_planner',
    name: 'Travel Planner',
    description: 'Organize your trip details',
    category: TemplateCategory.personal,
    icon: '✈️',
    content: '''# Trip to [Destination]

**Dates:** [Start] - [End]
**Budget:** \$[Amount]

## Itinerary
### Day 1 - [Date]
- Morning: 
- Afternoon: 
- Evening: 

### Day 2 - [Date]
- Morning: 
- Afternoon: 
- Evening: 

## Packing List
- [ ] 
- [ ] 
- [ ] 

## Bookings
- Flight: 
- Hotel: 
- Activities: 

## Important Notes
- 
''',
    backgroundId: 'ocean',
  );

  static const Template bookNotes = Template(
    id: 'book_notes',
    name: 'Book Notes',
    description: 'Capture insights from your reading',
    category: TemplateCategory.creative,
    icon: '📚',
    content: '''# Book Notes: [Title]

**Author:** [Name]
**Genre:** [Type]
**Started:** [Date]
**Finished:** [Date]

## Summary
[Brief overview]

## Key Takeaways
1. 
2. 
3. 

## Favorite Quotes
> ""

> ""

## My Thoughts
[Personal reflection]

## Rating: ⭐⭐⭐⭐⭐

## Would I Recommend? 
[Yes/No and why]
''',
    backgroundId: 'gradient_purple',
  );

  static const Template brainstorm = Template(
    id: 'brainstorm',
    name: 'Brainstorm',
    description: 'Capture creative ideas freely',
    category: TemplateCategory.creative,
    icon: '💡',
    content: '''# Brainstorm: [Topic]

## Initial Thoughts
- 
- 
- 

## Wild Ideas (No Judgment!)
- 
- 
- 

## Connections & Patterns
- 

## Most Promising Ideas
1. 
2. 
3. 

## Next Steps
- [ ] 
- [ ] 
''',
    backgroundId: 'gradient_pink',
  );

  static const Template businessPlan = Template(
    id: 'business_plan',
    name: 'Business Plan',
    description: 'Outline your business strategy',
    category: TemplateCategory.business,
    icon: '💼',
    content: '''# Business Plan: [Business Name]

## Executive Summary
[Brief overview]

## Mission Statement
[Your purpose]

## Target Market
- Who: 
- Needs: 
- Size: 

## Products/Services
- 
- 

## Marketing Strategy
- 
- 

## Financial Projections
- Startup Costs: 
- Revenue Goals: 

## Key Milestones
1. 
2. 
3. 

## Challenges & Solutions
- 
''',
    backgroundId: 'color_dark',
  );

  static const Template pitchDeck = Template(
    id: 'pitch_deck',
    name: 'Pitch Deck',
    description: 'Structure your business pitch',
    category: TemplateCategory.business,
    icon: '🎤',
    content: '''# Pitch Deck: [Company Name]

## Problem
[What problem are you solving?]

## Solution
[Your unique solution]

## Market Opportunity
- Market Size: 
- Growth Rate: 

## Product Demo
[Key features]

## Business Model
[How do you make money?]

## Traction
- Users: 
- Revenue: 
- Growth: 

## Competition
[Who else does this? Why are you better?]

## Team
[Who's building this?]

## Ask
[What do you need?]
''',
    backgroundId: 'gradient_ocean',
  );

  static const Template prospectOutreach = Template(
    id: 'prospect_outreach',
    name: 'Sales Outreach',
    description: 'Template for reaching out to prospects',
    category: TemplateCategory.business,
    icon: '📧',
    content: '''# Outreach: [Prospect Name]

## Research Notes
- Company: 
- Role: 
- Pain Points: 
- Recent News: 

## Email Draft
**Subject:** [Compelling subject line]

Hi [Name],

[Opening - show you did research]

[Problem they likely face]

[How you can help]

[Soft call to action]

Best,
[Your name]

## Follow-up Sequence
- Day 3: 
- Day 7: 
- Day 14: 
''',
    backgroundId: 'color_blue',
  );

  static const Template dreamLog = Template(
    id: 'dream_log',
    name: 'Dream Log',
    description: 'Record and analyze your dreams',
    category: TemplateCategory.personal,
    icon: '🌙',
    content: '''# Dream Log - [Date]

## Dream Summary
[What happened?]

## Key Symbols
- 
- 
- 

## Emotions Felt
- 

## People/Places
- 
- 

## Recurring Themes
- 

## Interpretation
[What might this mean?]

## Clarity: [Vivid/Hazy/Fragments]
''',
    backgroundId: 'space',
  );

  static const Template habitTracker = Template(
    id: 'habit_tracker',
    name: 'Habit Tracker',
    description: 'Track daily habits and build consistency',
    category: TemplateCategory.health,
    icon: '✅',
    content: '''# Habit Tracker - [Month]

## Daily Habits
- [ ] Drink 8 glasses of water
- [ ] Exercise 30 min
- [ ] Read 20 pages
- [ ] Meditate 10 min
- [ ] Journal
- [ ] [Custom habit]

## Weekly Goals
- [ ] 
- [ ] 
- [ ] 

## Monthly Target
[What do you want to achieve?]

## Progress Notes
Week 1: 
Week 2: 
Week 3: 
Week 4: 

## Streak: 🔥 [X] days
''',
    backgroundId: 'gradient_mint',
  );

  static const Template moodTracker = Template(
    id: 'mood_tracker',
    name: 'Mood Tracker',
    description: 'Track your emotional wellbeing',
    category: TemplateCategory.health,
    icon: '😊',
    content: '''# Mood Tracker - [Date]

## Current Mood: [😊/😐/😔]

## Energy Level: [1-10]

## Sleep Quality: [1-10]

## What Went Well
- 
- 

## Challenges
- 

## Triggers
[What affected my mood?]
- 

## Coping Strategies Used
- 

## Gratitude
1. 
2. 
3. 

## Tomorrow's Intention
''',
    backgroundId: 'gradient_lavender',
  );

  static const Template blogOutline = Template(
    id: 'blog_outline',
    name: 'Blog Outline',
    description: 'Structure your blog post',
    category: TemplateCategory.creative,
    icon: '✍️',
    content: '''# Blog Post: [Title]

## Target Audience
[Who is this for?]

## Main Takeaway
[What will readers learn?]

## Hook/Opening
[Grab attention]

## Outline
1. **Introduction**
   - 

2. **Main Point 1**
   - 
   - 

3. **Main Point 2**
   - 
   - 

4. **Main Point 3**
   - 
   - 

5. **Conclusion**
   - 
   - Call to action: 

## SEO Keywords
- 
- 

## Related Topics to Link
- 
''',
    backgroundId: 'color_lavender',
  );

  static const Template problemSolving = Template(
    id: 'problem_solving',
    name: 'Problem Solving',
    description: 'Work through complex problems',
    category: TemplateCategory.productivity,
    icon: '🧩',
    content: '''# Problem Solving: [Problem]

## Problem Definition
[What exactly is the issue?]

## Why It Matters
[Impact if not solved]

## Current Situation
[Facts and data]

## Root Causes
1. 
2. 
3. 

## Possible Solutions
**Option 1:**
- Pros: 
- Cons: 
- Effort: 

**Option 2:**
- Pros: 
- Cons: 
- Effort: 

**Option 3:**
- Pros: 
- Cons: 
- Effort: 

## Chosen Solution
[Which and why?]

## Action Plan
1. 
2. 
3. 

## Success Metrics
[How will you know it worked?]
''',
    backgroundId: 'color_orange',
  );

  static const Template oneOnOneAgenda = Template(
    id: 'one_on_one',
    name: '1-on-1 Agenda',
    description: 'Structured template for 1-on-1 meetings',
    category: TemplateCategory.business,
    icon: '👥',
    content: '''# 1-on-1: [Name] - [Date]

## How are you doing?
[Personal check-in]

## Recent Wins
- 
- 

## Challenges/Blockers
- 

## Project Updates
- 
- 

## Career Development
[Goals, growth areas]

## Feedback
**For you:**

**For me:**

## Action Items
- [ ] 
- [ ] 

## Next Meeting: [Date]
''',
    backgroundId: 'color_sky',
  );

  static const Template eventPlanning = Template(
    id: 'event_planning',
    name: 'Event Planning',
    description: 'Organize all event details',
    category: TemplateCategory.personal,
    icon: '🎉',
    content: '''# Event: [Name]

**Date:** [Date]
**Time:** [Start - End]
**Location:** [Venue]
**Expected Guests:** [Number]

## Checklist
### 8 Weeks Before
- [ ] Set date and budget
- [ ] Book venue
- [ ] Create guest list

### 4 Weeks Before
- [ ] Send invitations
- [ ] Plan menu
- [ ] Book vendors

### 1 Week Before
- [ ] Confirm RSVPs
- [ ] Final headcount
- [ ] Prepare decorations

### Day Of
- [ ] Set up venue
- [ ] Coordinate vendors
- [ ] Enjoy!

## Budget
- Venue: \$
- Food: \$
- Decorations: \$
- Other: \$
**Total:** \$

## Notes
''',
    backgroundId: 'gradient_pink',
  );

  // All templates list
  static const List<Template> all = [
    meetingNotes,
    dailyJournal,
    projectPlan,
    weeklyReview,
    groceryList,
    workoutLog,
    recipeTemplate,
    travelPlanner,
    bookNotes,
    brainstorm,
    businessPlan,
    pitchDeck,
    prospectOutreach,
    dreamLog,
    habitTracker,
    moodTracker,
    blogOutline,
    problemSolving,
    oneOnOneAgenda,
    eventPlanning,
  ];

  // Get templates by category
  static List<Template> getByCategory(TemplateCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  // Get template by ID
  static Template? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
