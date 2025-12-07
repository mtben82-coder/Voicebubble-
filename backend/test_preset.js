import { buildMessages, getPresetParameters } from './prompt_engine/builder.js';

const test1 = buildMessages({
  presetId: 'dating_opener',
  userText: 'her bio says she loves yoga and travel',
  language: 'en'
});

const test2 = buildMessages({
  presetId: 'social_viral_caption', 
  userText: 'talk about being single and not settling',
  language: 'en'
});

console.log('=== DATING OPENER TEST ===');
console.log(JSON.stringify(test1[0].content.substring(0, 500), null, 2));
console.log('\n=== SOCIAL VIRAL TEST ===');
console.log(JSON.stringify(test2[0].content.substring(0, 500), null, 2));
