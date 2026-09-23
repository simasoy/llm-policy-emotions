# Emotion in LLM policy outputs: a feasibility pilot

How do large language models express and frame emotions when politicians and civil servants use them, and how does that change with the way they are prompted?

This repository is a small, open pilot built to test whether that question can be studied systematically. It was prepared alongside an application to the A.I. Feels project (University of Amsterdam), sub-project 1. It is a **feasibility pilot, not a set of findings**.

Author: Sima Soy

## Research question

**How do LLMs express and frame emotions in response to politically relevant prompts, and how does this emotional expression change under different prompting conditions?**

- **Expression**: which emotional cues are present? Fear, anxiety, anger, hope, enthusiasm, compassion, moral concern.
- **Framing**: how does emotion structure the interpretation of the policy problem?
  *"Housing affordability is an urgent threat to young families"* versus *"Housing affordability is a structural economic challenge."*

| | Sub-question | In this repo |
|---|---|---|
| **RQ1 Presence** | What emotional expressions and frames are present in LLM responses to policy prompts? | `src/analyze.py` → `results/rq1_*` |
| **RQ2 Conditions** | Under which prompting conditions do LLMs produce different forms or intensities of emotional expression? | `src/analyze.py` → `results/rq2_*` |
| **RQ3 Measurement** | Can emotional expression in LLM political text be measured validly and reliably? Do automated classification, human coding and interpretive reading identify the same phenomena? | `src/agreement.py`, `templates/interpretive_memo.md` |

## Design

**Prompts** (`prompts/`): 4 topics × 5 policy tasks × 5 conditions = **100 prompts**.

| Topics (varying emotional charge) | Tasks (typical uses) | Conditions |
|---|---|---|
| Immigration and asylum | Briefing note for a minister (civil servant) | **Baseline**: no instruction (control) |
| Housing affordability | Policy options memo (civil servant) | **Neutral**: "Provide an objective, balanced assessment." |
| Climate and energy transition | Plenary speech (MP) | **Empathy**: "Consider the experiences and concerns of the people affected." |
| Pension reform | Reply to a worried constituent (MP) | **Risk**: "Focus on the risks and potential negative consequences." |
| | Social media post (MP) | **Solution**: "Focus on constructive and hopeful policy solutions." |

The baseline condition matters: "neutral" is itself an instruction, so without a no-instruction control we could not see the model's default emotional register.

Each prompt is sent to several models, 5 times each, to capture variation between samples.

**Measurement**: three lenses on the same texts.

1. **Dictionary** (`src/lexicon.py`): transparent cue-word counts. Crude on purpose, as a baseline.
2. **LLM coder** (`src/llm_coder.py`): a separate model applies the codebook, blind to condition.
3. **Human coding** (`codebook.md`): a blinded, stratified sample, with 20% double-coded for reliability.
4. **Interpretive memos** (`templates/interpretive_memo.md`) for a small subsample: feeling rules, absences, emotion strategies.

The codebook separates emotion that is **expressed** in the text's own voice ("I am angry that...") from emotion that is **attributed** to others ("voters are worried"). This distinction matters for LLM text: a briefing note can describe public anxiety without expressing it, and a speech draft can put emotion into a politician's mouth.

## Run it

```bash
pip install -r requirements.txt
cd src

# 1. Build the prompt matrix
python build_prompts.py

# 2. Collect outputs (set API keys first, e.g. export OPENAI_API_KEY=...)
python generate.py --limit 10          # quick test
python generate.py                     # full run; safe to stop and resume

# 3. Automated measures
python lexicon.py
python llm_coder.py

# 4. Human coding: sample, code in Excel/Sheets, save as data/coding/coded_A.csv
python sample_for_coding.py --n 60

# 5. Analysis
python agreement.py --coder ../data/coding/coded_A.csv --coder2 ../data/coding/coded_B.csv
python analyze.py --source llm
python analyze.py --source lexicon
```

To test the pipeline without API keys, run `bash run_mock.sh`. It generates fake outputs and writes everything to `data/mock/` and `results/mock/`. **Mock results are meaningless by design** and are not committed.

## Repository

```
prompts/        topics, tasks, conditions, models; prompt_matrix.csv is generated
codebook.md     emotion and framing codebook (v0.1)
templates/      interpretive memo template
src/            pipeline scripts
data/raw/       model outputs (JSONL), one record per response with full metadata
data/coding/    blinded coding sheets and keys
results/        tables and figures
docs/           pilot note
```

## Known limitations of this pilot

- English only. The full design would add Dutch, French and German, since policy is made in many languages and emotional norms differ between them.
- The prompts are researcher-written. The next step is to ground them in how officials actually prompt, through short interviews, or in real texts such as parliamentary written questions.
- The dictionary is a seed list, not a validated instrument.
- Model versions change. Every record stores the model name and collection date.
- Human coding in the pilot is done by one coder plus a second coder on a subsample.

## Theoretical anchors

- Ischen, Wang & Smit (2026), on human-likeness perception of text-based agents and why measures need testing in the context where they are used.
- Rebasso, Schumacher & Rooduijn (2026), on overlapping appraisal profiles of negative political emotions, which motivates the fear/anxiety and anger/moral concern checks in RQ3.
- Bos & Sanchez Salgado (2025), on moral frames and emotions in climate appeals.
- Sanchez Salgado & Gürkan (2025), on emotions, feeling rules and policy responses after Qatargate.
- Sanchez Salgado (2021), on emotion strategies of civil society organisations.
