export const meta = {
  name: 'doorbell-loop',
  description: 'Poll for new/updated PRs and run the doorbell-notify skill on each.'
};

// Fetch PRs updated since last run (store timestamp in a file for simplicity)
const { updatedSince } = await agent(`Read the timestamp from .doorbell-loop-timestamp or default to 1 hour ago.`, {
  schema: { type: 'object', properties: { updatedSince: { type: 'string'} } }
});

const prList = await agent(
  `gh pr list --state open --json number,updatedAt -q '[.[] | select(.updatedAt > "' + updatedSince + '")] | map({number: .number, title: .title})'`,
  { schema: { type: 'array', items: { type: 'object', properties: { number: {type:'string'}, title:{type:'string'} } } } }
);

// Process each PR (max 5 concurrent agents)
await pipeline(prList.slice(0,5), async (pr) => {
  await agent(
    `Process PR #${pr.number} (“${pr.title}”) with the doorbell-notify skill.`,
    { label: `pr-${pr.number}`, tools: ["Read","Edit","Bash","Glob","Grep"] }
  );
});

// Update timestamp for next run
await agent(`Write current ISO timestamp to .doorbell-loop-timestamp.`, {});