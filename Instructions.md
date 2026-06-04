# Stage1


# Prerequisites
### 1. DOwnload git
### 2. Clone the repo https://github.com/FiraXEdu/AgenticAI-Project.git
### 3. Open the codebase with VSCode
### 4. Install python -laptop
### 5. Add python extension in the VScode
### 6. Add copilot extension in the VScode
### 7. Go to Github Org -> settings -> billing & licenses -> Budgets & alerts
### Verify Copilot options Agent mode, Ask mode, Plan mode

## setup DataSOurce
### 1. Create a stoarge account as Datasource
### 2. Create resource group "TravelAIRG" , Storage account - aistgr456 Location "EASTUS"
### 3. Create a storage container (konseematravel) to store data 
### 4. Add data (folders collateral & reviews) with storage container(konseematravel)
-----------------------------------------
## Install dependencies
### 1.Install Python
### 2. Install req


# Stage2


## Setup AI Search Service
### 1. Create Azure AI search
Search Service name: travelsearchsvc
Resource Group: TravelAIRG
Location: East US
tier: Free tier
### 2. Import data source: -> Azure Blob storage
### 3. Targeting scenario: Keyword search
### 4. COnfigure Blob storage with AI searach
   Select storage Account
   Select blob storage
### 5. Enrich your data
      Slect all options

### 6. Attach a Foundry Tools multi-service account
    Create multi service account with API key
### 7. Review Preview index fields
### 8. Schedule indexing --> select --> once
### 9. Review & create    
### 10. update env file ai search attributes


# Stage3


## Configure Azure AI Search
### 1. Go to -> .env -> update SEARCH_SERVICE_ENDPOINT , SEARCH_SERVICE_QUERY_KEY, SEARCH_INDEX_NAME

## Create Azure AI Foundry
### 1. Goto Microsft Foundry -> Create foundy project
### 2. Goto Foundry Portal -> Model catalog
### 3. Explore Model Capabilities 
https://ai.azure.com/catalog


# Stage4
------------------------------------------
------------------------------------------

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEVELOPER MACHINE                         │
│  rag_app.py  +  requirements.txt  +  templates/                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ git push
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                       AZURE DEVOPS                               │
│                                                                   │
│   ┌─────────────────┐        ┌──────────────────────────┐        │
│   │  BUILD PIPELINE  │──────▶│    RELEASE PIPELINE       │        │
│   │                  │       │                            │        │
│   │ • Python 3.11    │       │ • Download app.zip         │        │
│   │ • pip install    │       │ • Deploy to App Service    │        │
│   │ • Archive → ZIP  │       │ • Set startup command      │        │
│   │ • Publish artifact│      │ • Smoke test               │        │
│   └─────────────────┘       └──────────────┬─────────────┘        │
└──────────────────────────────────────────────┼─────────────────┘
                                               │ deploy
                                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AZURE CLOUD                                  │
│                                                                   │
│   Resource Group: rg-rag-app                                      │
│   ┌──────────────────────────────────────────────────────────┐   │
│   │  App Service Plan (B2, Linux)                             │   │
│   │  ┌────────────────────────────────────────────────────┐  │   │
│   │  │  Web App: rag-app-<id>.azurewebsites.net            │  │   │
│   │  │  Runtime: Python 3.11                               │  │   │
│   │  │  Startup: gunicorn --workers=4 rag_app:app          │  │   │
│   │  └────────────────────────────────────────────────────┘  │   │
│   └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│   ┌──────────────────────┐   ┌──────────────────────────────┐    │
│   │  Azure AI Search      │   │  Azure OpenAI                │    │
│   │  aieastsrch001        │   │  aifndry009785               │    │
│   │  Index: search-178... │   │  Deployment: gpt-4.1         │    │
│   └──────────────────────┘   └──────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| Azure Subscription | Active subscription with Contributor access |
| Azure DevOps Account | Free at [dev.azure.com](https://dev.azure.com) |
| Git | Installed locally |
| Python 3.11 | Installed locally for testing |
| Azure AI Search | Already provisioned (`aieastsrch001`) |
| Azure OpenAI | Already provisioned (`aifndry009785`) |

---

## Part 1 — Local App Preparation

Do these steps on your machine **before** touching the Azure Portal.

### 1.1 — Update `requirements.txt`

Add the production server packages:

```
flask
azure-search-documents
openai
gunicorn==21.2.0
waitress==2.1.2
```

### 1.2 — Update `rag_app.py`

Remove debug mode for production:

```python
# ❌ Change this (development only):
app.run(debug=True)

# ✅ To this (production):
app.run()
```

### 1.3 — Test Locally with Gunicorn

```bash
gunicorn --bind=0.0.0.0 --workers=4 rag_app:app
```

Visit `http://localhost:8000` — confirm it works before proceeding.

### 1.4 — Add `.artifactignore` File (Tells the Build What to Exclude)

Instead of creating a ZIP manually, the **Build Pipeline** (Part 3) handles this automatically. However, you must tell it which files to exclude by adding a `.artifactignore` file to your project root.

Create a file called `.artifactignore` in the root of your project:

```
# Python cache
**/__pycache__/
**/*.pyc
**/*.pyo
**/*.pyd

# Virtual environments
.venv/
venv/
env/

# Local secrets — never deploy
.env
*.env

# Git metadata
.git/
.gitignore

# Dev/test files
tests/
*.test.py
pytest.ini
.pytest_cache/

# IDE files
.vscode/
.idea/

# Local zip artifacts
*.zip
```

> ✅ **This file is the only manual step needed.** The Build Pipeline's Archive task reads this and automatically excludes these paths when creating `app.zip`. No manual zipping required ever again — every deployment is created fresh by the pipeline from clean source code.

---

## Part 2 — Azure Portal: Infrastructure Setup

Go to **[portal.azure.com](https://portal.azure.com)** for all steps below.

---

### Step 1 — Create Resource Group

1. Search **"Resource groups"** in the top search bar → click it
2. Click **+ Create**
3. Fill in:

   | Field | Value |
   |---|---|
   | Subscription | Your subscription |
   | Resource group name | `rg-rag-app` |
   | Region | `East US` |

4. Click **Review + Create** → **Create**

---

### Step 2 — Create App Service Plan

1. Search **"App Service plans"** → click it
2. Click **+ Create**
3. Fill in:

   | Field | Value |
   |---|---|
   | Resource group | `rg-rag-app` |
   | Name | `plan-rag-app` |
   | Operating System | `Linux` |
   | Region | `East US` |
   | Pricing plan | `B2` (Basic — click "Explore pricing plans" to select) |

4. Click **Review + Create** → **Create**

---

### Step 3 — Create Web App

1. Search **"App Services"** → click it
2. Click **+ Create** → **Web App**
3. Fill in the **Basics** tab:

   | Field | Value |
   |---|---|
   | Resource group | `rg-rag-app` |
   | Name | `rag-app-<your-unique-id>` (e.g. `rag-app-12345`) |
   | Publish | `Code` |
   | Runtime stack | `Python 3.11` |
   | Operating System | `Linux` |
   | Region | `East US` |
   | App Service Plan | `plan-rag-app` |

4. Click **Review + Create** → **Create**
5. After deployment finishes → click **Go to resource**