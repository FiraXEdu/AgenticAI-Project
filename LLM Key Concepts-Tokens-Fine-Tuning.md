LLM Key Concepts, Tokens & Fine-Tuning
**Agentic AI Engineer Program | FiraXEdu**

---

## Part 1 — LLM Key Concepts 


| Slide(s) | Time | Do |
|---|---|---|
| 1–3 (Title, Token, Tokenization flow)
| 5 (Temperature) |
| 7 (Sampling params incl. Context Window)   |
| 8 (Prompt Structure) 
| 9 (Embeddings & RAG) 
| 10 (Fine-Tuning vs RAG, Hallucination)
| 11–12 (More terms, Cheat sheet)

**Part 2:** *"We just said tokens are what you're billed for — now let's actually look at the bill."*

---

## 🔵 FOUNDRY DEMO #1 — Temperature, live 
1. Switch to the pre-opened **Chat Playground** tab in Azure AI Foundry.
2. Send the same prompt twice — once with temperature near 0, once above 0.7.
3. Point out the visible difference in wording/structure between runs.
**:** *" slider just watched is exactly the temp=0.0 vs temp=1.0 row on the slide."*

## 🔵 FOUNDRY DEMO #2 — Context window, live 
1. Switch to a **model card** in the Foundry model catalog.
2. Point at the published context length field.
*:** *"200K tokens isn't a slide number — it's a spec you'll check every time you pick a model for a project."*

---

## Part 2 — Input vs Output Tokens 

*"You already understand cloud billing — EC2, S3. LLM billing works the same way. Today's unit is called a token."*

| Slide(s) | Time | Do |
|---|---|---|
| 1–3 (Title, visual flow, What is a token) 
| 5 (Input vs Output token types)

| 7 (Cloud Compute Analogy) 
| 9 (Real pricing, worked example) 
| 10 (Agentic AI — tokens compound per loop) 
| 11 (3 rules to remember)

** Part 3:** *"just covered cost. Now — one of the two big levers for making a model actually behave the way you want, without paying for every token of context every time: fine-tuning."*

---

## 🔵 FOUNDRY DEMO #3 — Real token usage, live (after Slide 9)
1. Switch to the **Chat Playground** tab again.
2. Send one real prompt/response.
3. Open the response's usage/metadata panel — show the actual input/output token counts Foundry reports.


---

## Part 3 — Fine-Tuning Explained 


| Slide(s) | Time | Do |
|---|---|---|
| 1–4 (Title, What is FT, Doctor analogy, How it works)  The doctor analogy is the one students will repeat back — let it breathe. |
| 5 (Before/after example) 
| 6 (6-step workflow) | **🔵 FOUNDRY DEMO #4** — see below |
| 7 (What actually changes) 
| 8 (Common use cases grid)  
| 9 (Decision tree image) 
| 11 (FT vs Prompt Eng vs RAG table)
| 12–13 (All-three-together diagram, When to fine-tune) 
*"Fine-tuning teaches how to think. RAG teaches what to know."* |

---

## 🔵 FOUNDRY DEMO #4 — Fine-tuning workflow, 
1. Switch to Foundry's **Fine-tuning** tab.
2. Watch the real UI, matching each of the deck's 6 steps as you click through: select base model → upload training file → configure → submit job → monitor status → deploy.


## 🔵 FOUNDRY DEMO #5 — 
1. Point out, in the Foundry left nav: **Playground** (prompt engineering), a connected **Azure AI Search** resource (RAG), **Fine-tuning** tab (fine-tuning).


---


*"Tokens are what you pay for. Temperature and sampling are how you control the output. RAG and fine-tuning are how you make the model know your world or think in your voice. Everything from here on in this program builds on these five ideas."*

---

## Quick Checklist

- [ ] Azure AI Foundry Playground tab open, logged in, model deployed
- [ ] A model card open in the model catalog (for context-window demo)
- [ ] Fine-tuning tab open 


