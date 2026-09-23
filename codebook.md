# Codebook: emotional expression and framing in LLM policy outputs

Version 0.1 (pilot). This codebook is used by human coders and, in condensed form, by the automated LLM coder (`src/llm_coder.py`). Disagreements between the two are data for RQ3, not only error.

## Unit of analysis

One model response to one prompt. Code the whole response.

## Core distinction: whose emotion, and in which mode

A briefing note may say "residents feel anxious about the pace of change". A speech may say "I am angry that families are waiting years for a home". Both contain emotion, but they do different things. Code both dimensions for every emotion you mark as present.

**Mode**
- `expressed`: the text itself carries the emotion, in the voice of the speaker (the politician, the ministry, the model).
- `attributed`: the text describes or reports an emotion held by someone else ("voters are worried").
- `both`

**Target / holder**
- `speaker`: the voice of the text (the MP, the ministry)
- `public`: citizens in general, voters, society
- `affected`: a specific affected group (asylum seekers, young families, pensioners)
- `opponents`: other parties, institutions, blamed actors
- `model`: the model speaking as itself ("I understand this is a difficult topic")

## 1. Emotions (Expression)

Score each emotion for intensity:

| Score | Meaning |
|---|---|
| 0 | Absent |
| 1 | Implicit or mild: a single cue, or an emotion implied by word choice |
| 2 | Explicit: clearly present, named or strongly cued, but not dominant |
| 3 | Dominant: the emotion organises the text |

| Emotion | Definition in text | Typical cues | Not to be confused with |
|---|---|---|---|
| **Fear** | Presents a concrete threat of harm, danger or loss | threat, danger, at risk, crisis, catastrophic, cannot afford to wait | Anxiety (diffuse, uncertain) |
| **Anxiety** | Diffuse worry or uncertainty about what may happen | uncertain, worry, unclear, unease, concerns about the future | Fear (specific, imminent threat) |
| **Anger** | Blame or indignation directed at an agent seen as responsible | unacceptable, failed, outrageous, betrayed, enough is enough | Moral concern without a blamed agent |
| **Hope** | Positive expectation that things can improve | can, together, a better future, opportunity, within reach | Enthusiasm (higher arousal) |
| **Enthusiasm** | High-energy positive affect: pride, excitement, determination | proud, bold, exciting, ambitious, let's seize | Hope (calmer, future-oriented) |
| **Compassion** | Concern for the suffering or hardship of others | struggling families, vulnerable, hardship, dignity, no one left behind | Moral concern (principle rather than suffering) |
| **Moral concern** | Appeal to rightness, fairness, duty or rights | fair, just, responsibility, obligation, rights, we owe | Anger (needs a blamed agent) |

**Known hard boundaries (flag them, don't force them):**
fear vs anxiety, and anger vs moral concern. Rebasso, Schumacher and Rooduijn (2026) find that negative political emotions share overlapping appraisal profiles. If you cannot separate two emotions, code both and write `overlap: fear/anxiety` in the notes. These cases are a planned focus of RQ3.

## 2. Framing

How does emotion structure the interpretation of the policy problem?

> "Housing affordability is an urgent threat to young families." (threat frame, urgency 2)
> "Housing affordability is a structural economic challenge." (structural frame, urgency 0)

**Dominant frame** (choose one):

| Frame | The problem is presented as... |
|---|---|
| `threat` | a danger or crisis that must be averted |
| `structural` | a technical, economic or systemic issue to be managed |
| `moral` | a question of fairness, rights or duty |
| `human_interest` | a matter of individual people and their experiences |
| `opportunity` | a chance to improve or build something |

**Urgency** (0 to 2): 0 = no time pressure, 1 = some, 2 = presented as needing immediate action.

**Balance signalling** (yes/no): does the text explicitly perform neutrality ("on the one hand... on the other", "it is important to consider all perspectives")? This matters for civil-service neutrality and is a common LLM default.

## 3. Interpretive memo (subsample only)

For a small subsample, write a short memo using `templates/interpretive_memo.md`. It asks what the codes cannot capture: which feeling rules the text follows, what emotions it leaves out, and how it compares to how a human politician or civil servant would write the same text.

## Coding procedure

1. Coders see the text only. Model, condition and prompt are hidden (see `data/coding/`).
2. Read the full response once before coding.
3. Code emotions, then mode and target for each present emotion, then framing.
4. For reliability, a second coder codes at least 20% of the items independently.
