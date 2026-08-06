# Today's Class Flow — LLM Key Concepts, Tokens & Fine-Tuning
**Agentic AI Engineer Program | FiraXEdu | Print & keep open while teaching**

**Total runtime:** ~85–95 minutes | **Decks used:** 5_LLM_Key_Concepts → 6_Input_Output_Tokens → Fine_Tuning_Explained
**Tab open before class starts:** Azure AI Foundry portal (Playground + a model card + Fine-tuning tab pre-navigated in separate browser tabs)

---

## Part 1 — LLM Key Concepts (35–40 min)

**Opening line:** *"Today we're building the vocabulary you'll use for the rest of this program — tokens, temperature, and how to choose between RAG and fine-tuning. Every one of these you'll see again live inside Azure AI Foundry."*

| Slide(s) | Time | Do |
|---|---|---|
| 1–3 (Title, Token, Tokenization flow) | 8 min | Run as-is. Emphasize: token ≈ ¾ word, BPE splits rare words. |
| 5 (Temperature) | 5 min | **🔵 FOUNDRY DEMO #1** — see below |
| 7 (Sampling params incl. Context Window) | 6 min | **🔵 FOUNDRY DEMO #2** — see below |
| 8 (Prompt Structure) | 4 min | Run as-is. Tie to system/user/assistant roles they'll write in code. |
| 9 (Embeddings & RAG) | 5 min | Run as-is. Flag: "we go much deeper on this in the Vectors & Vector DB session." |
| 10 (Fine-Tuning vs RAG, Hallucination) | 5 min | Run as-is. This table is the seed for Part 3 today — say so explicitly. |
| 11–12 (More terms, Cheat sheet) | 4 min | Quick pass. Tell students the cheat sheet slide is their reference card. |

**Transition line into Part 2:** *"We just said tokens are what you're billed for — now let's actually look at the bill."*

---

## 🔵 FOUNDRY DEMO #1 — Temperature, live (after Slide 5)
1. Switch to the pre-opened **Chat Playground** tab in Azure AI Foundry.
2. Send the same prompt twice — once with temperature near 0, once above 0.7.
3. Point out the visible difference in wording/structure between runs.
**Say:** *"That slider you just watched me move is exactly the temp=0.0 vs temp=1.0 row on the slide."*

## 🔵 FOUNDRY DEMO #2 — Context window, live (after Slide 7)
1. Switch to a **model card** in the Foundry model catalog.
2. Point at the published context length field.
**Say:** *"200K tokens isn't a slide number — it's a spec you'll check every time you pick a model for a project."*

---

## Part 2 — Input vs Output Tokens (20–25 min)

**Opening line:** *"You already understand cloud billing — EC2, S3. LLM billing works the same way. Today's unit is called a token."*

| Slide(s) | Time | Do |
|---|---|---|
| 1–3 (Title, visual flow, What is a token) | 5 min | Run as-is. |
| 5 (Input vs Output token types) | 4 min | Run as-is. Emphasize the arrow through the LLM: reading is cheap, generating is expensive. |
| 7 (Cloud Compute Analogy) | 5 min | Run as-is — this is the strongest slide in the deck. Let it land before moving on. |
| 9 (Real pricing, worked example) | 5 min | **🔵 FOUNDRY DEMO #3** — see below |
| 10 (Agentic AI — tokens compound per loop) | 5 min | Run as-is, then explicitly reconnect to the multi-agent orchestration diagram from the earlier session — same boxes, now with a token cost attached to each hop. |
| 11 (3 rules to remember) | 2 min | Quick recap. |

**Transition line into Part 3:** *"We just covered cost. Now — one of the two big levers for making a model actually behave the way you want, without paying for every token of context every time: fine-tuning."*

---

## 🔵 FOUNDRY DEMO #3 — Real token usage, live (after Slide 9)
1. Switch to the **Chat Playground** tab again.
2. Send one real prompt/response.
3. Open the response's usage/metadata panel — show the actual input/output token counts Foundry reports.
**Say:** *"Swap the deck's example numbers for these — same math, your own bill."*

---

## Part 3 — Fine-Tuning Explained (25–30 min)

**Opening line:** *"Slide 10 from Part 1 showed RAG vs fine-tuning as a table. Let's go deep on the fine-tuning side of that table."*

| Slide(s) | Time | Do |
|---|---|---|
| 1–4 (Title, What is FT, Doctor analogy, How it works) | 8 min | Run as-is. The doctor analogy is the one students will repeat back — let it breathe. |
| 5 (Before/after example) | 3 min | Run as-is. |
| 6 (6-step workflow) | 6 min | **🔵 FOUNDRY DEMO #4** — see below |
| 7 (What actually changes) | 3 min | Run as-is. |
| 8 (Common use cases grid) | 3 min | Quick pass — ask the room which of the 8 maps to their own work. |
| 9 (Decision tree image) | 3 min | Run as-is — clean visual, no narration needed beyond reading it aloud once. |
| 11 (FT vs Prompt Eng vs RAG table) | 4 min | Run as-is. |
| 12–13 (All-three-together diagram, When to fine-tune) | 5 min | **🔵 FOUNDRY DEMO #5** — see below. Close on the key takeaway: *"Fine-tuning teaches how to think. RAG teaches what to know."* |

---

## 🔵 FOUNDRY DEMO #4 — Fine-tuning workflow, live (after Slide 6)
1. Switch to Foundry's **Fine-tuning** tab.
2. Walk the real UI, matching each of the deck's 6 steps as you click through: select base model → upload training file → configure → submit job → monitor status → (note, don't actually run) deploy.
**Say:** *"Every box on that slide is a screen you just watched me click through."*

## 🔵 FOUNDRY DEMO #5 — Where all three live in Foundry (after Slide 12)
1. Point out, in the Foundry left nav: **Playground** (prompt engineering), a connected **Azure AI Search** resource (RAG), **Fine-tuning** tab (fine-tuning).
**Say:** *"The diagram you just saw isn't conceptual — it's these three tabs, used together on a real project."*

---

## Closing (2–3 min)

**Close the whole session with one line tying all three decks together:**
*"Tokens are what you pay for. Temperature and sampling are how you control the output. RAG and fine-tuning are how you make the model know your world or think in your voice. Everything from here on in this program builds on these five ideas."*

---

## Quick Checklist Before Class

- [ ] Azure AI Foundry Playground tab open, logged in, model deployed
- [ ] A model card open in the model catalog (for context-window demo)
- [ ] Fine-tuning tab open (don't need to actually submit a job — just navigate it)
- [ ] Test one Playground call beforehand so token-usage panel is warmed up / familiar to you
- [ ] Cheat sheet slide (Deck 1, Slide 12) ready to screen-share again at the very end if time allows
