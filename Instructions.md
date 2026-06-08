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

### Step 4 — Configure Environment Variables

1. In your Web App, go to **Settings → Environment variables** (left sidebar)
2. Click **+ Add** for each variable below:

   | Name | Value |
   |---|---|
   | `SEARCH_SERVICE_ENDPOINT` | `https://aieastsrch001.search.windows.net` |
   | `SEARCH_SERVICE_QUERY_KEY` | `<your-search-query-key>` |
   | `SEARCH_INDEX_NAME` | `search-1780140742934` |
   | `AZURE_OPENAI_ENDPOINT` | `https://aifndry009785.cognitiveservices.azure.com/` |
   | `AZURE_OPENAI_KEY` | `<your-openai-key>` |
   | `AZURE_OPENAI_DEPLOYMENT` | `gpt-4.1` |

3. Click **Apply** → **Confirm**

> ⚠️ **Security note:** Rotate these keys after initial setup. Use Azure Key Vault references for production.

---

### Step 5 — Set Startup Command

1. Go to **Settings → Configuration** (left sidebar)
2. Click the **General settings** tab
3. In the **Startup Command** field enter:

   ```
   gunicorn --bind=0.0.0.0 --workers=4 rag_app:app
   ```

4. Click **Save** → **Continue**

   or Use the below command

   az webapp config set --resource-group centralairg --name centralaiapp09 --startup-file "gunicorn --bind=0.0.0.0 --workers=4 rag_app:app"

---

### Step 6 — Enable Logging

1. Go to **Monitoring → App Service logs** (left sidebar)
2. Set **Application logging (Filesystem)** → **On**
3. Set **Web server logging** → **File System**
4. Click **Save**

---



## Part 3 — Azure DevOps CI/CD Classic Pipeline

After the first manual deploy, set up automation so every `git push` triggers a build and release automatically.

---

### Step 9 — Create DevOps Project & Push Code

1. Go to **[dev.azure.com](https://dev.azure.com)** → sign in
2. Click **+ New project**

   | Field | Value |
   |---|---|
   | Project name | `rag-app` |
   | Visibility | Private |

3. Click **Create**
4. Go to **Repos → Files** → copy the **Clone URL**
5. Push your local code:

   ```bash
   git init
   git remote add origin <clone-url>
   git add .
   git commit -m "initial commit"
   git push -u origin main
   ```

---

### Step 10 — Create Service Connection

This connects Azure DevOps to your Azure subscription for deployments.

1. Go to **Project Settings** (bottom-left gear ⚙️ icon)
2. Under **Pipelines** → click **Service connections**
3. Click **+ New service connection** → choose **Azure Resource Manager**
4. Select **Service principal (automatic)**
5. Fill in:

   | Field | Value |
   |---|---|
   | Scope level | Subscription |
   | Subscription | Your subscription |
   | Resource group | `rg-rag-app` |
   | Service connection name | `azure-service-connection` |

6. Check **Grant access permission to all pipelines**
7. Click **Save**

---

### Step 11 — Classic Build Pipeline

#### 11.1 — Create the Pipeline

1. Go to **Pipelines → Pipelines** (left sidebar)
2. Click **New pipeline**
3. At the bottom click **"Use the classic editor"** ← important
4. Source: **Azure Repos Git**
5. Select your **Repository** and **Branch** (`main`) → click **Continue**
6. Search for **"Python package"** template → click **Apply**

#### 11.2 — Configure Agent

Click **Agent job 1** and set:

| Field | Value |
|---|---|
| Agent pool | `Azure Pipelines` |
| Agent Specification | `ubuntu-latest` |

#### 11.3 — Add Build Tasks

Click **"+"** on Agent job 1 and add tasks in this order:

---

**Task 1 — Use Python Version**

| Field | Value |
|---|---|
| Task | Use Python Version |
| Version spec | `3.11` |
| Add to PATH | ✅ checked |

---

**Task 2 — Install Dependencies**

| Field | Value |
|---|---|
| Task | Command Line |
| Display name | `Install Dependencies` |
| Script | (see below) |

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

---

**Task 3 — Archive Files (Automated ZIP Creation)**

> 🗜️ **This task replaces all manual ZIP creation.** It automatically packages your entire project into `app.zip` on every build — clean, consistent, and no developer action required. It respects your `.artifactignore` file to exclude unwanted files.

| Field | Value |
|---|---|
| Task | Archive Files |
| Root folder to archive | `$(System.DefaultWorkingDirectory)` |
| Prepend root folder name | ❌ unchecked — files go to ZIP root, not a subfolder |
| Archive type | `zip` |
| Archive file to create | `$(Build.ArtifactStagingDirectory)/app.zip` |
| Replace existing archive | ✅ checked |

**What this does step by step:**
1. Takes everything in `$(System.DefaultWorkingDirectory)` (your repo checkout)
2. Applies `.artifactignore` exclusions (no `.env`, no `__pycache__`, no `venv/`)
3. Creates a fresh `app.zip` in the staging directory
4. The ZIP is then picked up by Task 4 and published as a build artifact
5. The Release Pipeline downloads this exact ZIP and deploys it to Azure

> 💡 **Variable reference:**
> - `$(System.DefaultWorkingDirectory)` = the folder where your repo was checked out on the build agent
> - `$(Build.ArtifactStagingDirectory)` = a temp staging folder for files to be published

---

**Task 4 — Publish Build Artifact**

| Field | Value |
|---|---|
| Task | Publish Build Artifacts |
| Path to publish | `$(Build.ArtifactStagingDirectory)` |
| Artifact name | `drop` |
| Artifact publish location | Azure Pipelines |

#### 11.4 — Enable CI Trigger

1. Click the **Triggers** tab
2. Check **"Enable continuous integration"**
3. Branch filter → `main`

#### 11.5 — Save and Run

1. Click **Save & queue** → **Save and run**
2. Watch the build — it should complete with a green ✅
3. The `drop` artifact (containing `app.zip`) is now published and ready

---


# Release Stage:

### Step 12 — Classic Release Pipeline

#### 12.1 — Create the Pipeline

1. Go to **Pipelines → Releases** (left sidebar)
2. Click **+ New** → **New release pipeline**
3. Search for **"Azure App Service deployment"** → click **Apply**
4. Rename the stage from `Stage 1` to `Production`

#### 12.2 — Add Build Artifact

1. Click **"+ Add an artifact"** on the left side of the canvas
2. Fill in:

   | Field | Value |
   |---|---|
   | Source type | Build |
   | Project | your project |
   | Source (build pipeline) | your build pipeline |
   | Default version | Latest |
   | Source alias | `_drop` |

3. Click **Add**

#### 12.3 — Enable Continuous Deployment Trigger

1. Click the **lightning bolt ⚡ icon** on the artifact
2. Toggle **Continuous deployment trigger** → **Enabled**
3. Branch filter → `main`

> This means every successful build on `main` automatically triggers a release.

#### 12.4 — Configure the Production Stage

Click **"1 job, 1 task"** inside the Production stage box.

**Stage-level settings (top of tasks page):**

| Field | Value |
|---|---|
| Azure subscription | `azure-service-connection` |
| App type | `Web App on Linux` |
| App Service name | `rag-app-<your-unique-id>` |

**Deploy Azure App Service task:**

| Field | Value |
|---|---|
| Package or folder | `$(System.DefaultWorkingDirectory)/_drop/drop/app.zip` |
| Runtime Stack | `PYTHON\|3.11` |
| Startup command | `gunicorn --bind=0.0.0.0 --workers=4 rag_app:app` |
| Deployment method | `Run From Package` |

#### 12.5 — Add Smoke Test Task (Recommended)

Click **"+"** → add a **Command Line** task after the deploy task:

| Field | Value |
|---|---|
| Display name | `Smoke Test` |
| Script | (see below) |

```bash
echo "Waiting for app to start..."
sleep 30
curl -f https://rag-app-<your-id>.azurewebsites.net/ || exit 1
echo "✅ App is live and responding!"
```

#### 12.6 — Secure API Keys as Pipeline Variables

Instead of hardcoding secrets in app settings:

1. In the Release Pipeline → click **Variables** tab
2. Click **+ Add** for each secret:

   | Name | Value | Secured |
   |---|---|---|
   | `AZURE_OPENAI_KEY` | `<your-key>` | 🔒 Lock it |
   | `SEARCH_SERVICE_QUERY_KEY` | `<your-key>` | 🔒 Lock it |

3. In the **Deploy App Service task** → expand **"Application and Configuration Settings"**
4. In the **App settings** field add:

   ```
   -AZURE_OPENAI_KEY $(AZURE_OPENAI_KEY) -SEARCH_SERVICE_QUERY_KEY $(SEARCH_SERVICE_QUERY_KEY)
   ```

#### 12.7 — Save and Create First Release

1. Click **Save**
2. Click **+ Release** → **Create a release**
3. Select your artifact version → click **Create**
4. Click the release link → watch the **Production** stage run
5. Click **Logs** to see live deployment output

---

## End-to-End Flow

```
Developer pushes code to main branch
            │
            ▼
 ┌──────────────────────┐
 │   BUILD PIPELINE      │  (triggers automatically on push)
 │                        │
 │  1. Use Python 3.11    │
 │  2. pip install -r ... │
 │  3. Archive → app.zip  │  ← automated, no manual ZIP
 │     (.artifactignore   │
 │      excludes junk)    │
 │  4. Publish artifact   │
 └──────────┬───────────┘
            │  artifact: drop/app.zip
            ▼
 ┌──────────────────────┐
 │   RELEASE PIPELINE    │  (triggers automatically on build success)
 │                        │
 │  1. Download app.zip   │
 │  2. Deploy to App Svc  │
 │  3. Set startup cmd    │
 │  4. Smoke test curl    │
 └──────────┬───────────┘
            │
            ▼
 ✅  https://rag-app-xxxxx.azurewebsites.net
```

**Total estimated pipeline time: ~8–12 minutes per deployment**

---

## Environment Variables Reference

| Variable | Description | Example |
|---|---|---|
| `SEARCH_SERVICE_ENDPOINT` | Azure AI Search service URL | `https://aieastsrch001.search.windows.net` |
| `SEARCH_SERVICE_QUERY_KEY` | Query key for AI Search | `b5foG0kW...` |
| `SEARCH_INDEX_NAME` | Name of the search index | `search-1780140742934` |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI service URL | `https://aifndry009785.cognitiveservices.azure.com/` |
| `AZURE_OPENAI_KEY` | Azure OpenAI API key | `7Ll27jB1...` |
| `AZURE_OPENAI_DEPLOYMENT` | Model deployment name | `gpt-4.1` |

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---|---|---|
| `500 Internal Server Error` | App crash on startup | Check **Log stream** in Azure Portal |
| `Module not found` | Missing dependency | Verify `requirements.txt` is in project root |
| `Application Error` after deploy | Startup command wrong | Check **General settings → Startup command** |
| Build fails at `pip install` | Bad `requirements.txt` | Run `pip install -r requirements.txt` locally first |
| Release pipeline can't connect | Service connection issue | Re-create service connection in Project Settings |
| App deploys but AI Search returns no results | Wrong index name or key | Double-check environment variables in App Service |
| ZIP deploy fails in Kudu | File locked or too large | Restart App Service, try again |

**To stream live logs from the portal:**
> Web App → **Monitoring → Log stream**

---

## Security Best Practices

- 🔒 **Rotate API keys** after initial setup — never commit them to git
- 🔒 **Use Azure Key Vault** references in App Settings for production secrets
- 🔒 **Lock pipeline variables** (click the padlock icon) so keys don't appear in logs
- 🔒 **Restrict service connection** scope to `rg-rag-app` resource group only
- 🔒 **Enable HTTPS only** — Web App → Settings → TLS/SSL → HTTPS Only → On
- 🔒 **Add `.env` to `.gitignore`** to prevent accidental secret commits

---

## Quick Reference — Portal Navigation

| Task | Portal Path |
|---|---|
| View environment variables | Web App → Settings → Environment variables |
| Change startup command | Web App → Settings → Configuration → General settings |
| Stream live logs | Web App → Monitoring → Log stream |
| View deployment history | Web App → Deployment → Deployment Center |
| Restart the app | Web App → Overview → Restart |
| Scale up plan | App Service Plan → Settings → Scale up |
| View build results | Azure DevOps → Pipelines → Pipelines |
| View release history | Azure DevOps → Pipelines → Releases |

---


