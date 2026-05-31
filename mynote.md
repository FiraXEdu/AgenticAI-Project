Read [](file:///c%3A/Projects/1.AI%20Search/Azure%20AI%20Serach/README.md#1-1), lines 1 to 1

I'll create two separate documentation files for you. 

Searched for files matching `Azure AI Serach` · `*.md`, 1 match

Creating two separate documentation files for you:

## **File 1: WEBAPP_DEPLOYMENT.md**

```markdown
# Azure Web App Deployment Guide

## Prerequisites
- Azure CLI installed
- Azure subscription
- Git (for optional Git deploy)
- Local app tested and working

## Step-by-Step Deployment

### Step 1: Prepare Local App
1. Update `requirements.txt`:
   ```
   gunicorn==21.2.0
   waitress==2.1.2
   ```

2. Update `rag_app.py` — remove debug mode:
   ```python
   # Change this:
   app.run(debug=True)
   
   # To this:
   app.run()
   ```

3. Test locally with gunicorn:
   ```bash
   gunicorn --bind=0.0.0.0 --workers=4 rag_app:app
   ```

### Step 2: Create Resource Group
```bash
az group create --name rg-rag-app --location eastus
```

### Step 3: Create App Service Plan
```bash
az appservice plan create \
  --name plan-rag-app \
  --resource-group rg-rag-app \
  --sku B2 \
  --is-linux
```

### Step 4: Create Web App
```bash
az webapp create \
  --resource-group rg-rag-app \
  --plan plan-rag-app \
  --name rag-app-unique-id \
  --runtime "PYTHON:3.11"
```
*Replace `rag-app-unique-id` with a unique name (e.g., `rag-app-12345`)*

### Step 5: Configure Application Settings
```bash
az webapp config appsettings set \
  --resource-group rg-rag-app \
  --name rag-app-unique-id \
  --settings \
    SEARCH_SERVICE_ENDPOINT="https://aieastsrch001.search.windows.net" \
    SEARCH_SERVICE_QUERY_KEY="b5foG0kWhDnXnOE5ey1dPNih6pgNxARKxeg1T7d2fPAzSeBeyt6J" \
    SEARCH_INDEX_NAME="search-1780140742934" \
    AZURE_OPENAI_ENDPOINT="https://aifndry009785.cognitiveservices.azure.com/" \
    AZURE_OPENAI_KEY="7Ll27jB1tJwsKleU8a8kPDKms3lPqCZsuu8py4KRM3OYMUVF1d26JQQJ99CEACYeBjFXJ3w3AAAAACOG26VP" \
    AZURE_OPENAI_DEPLOYMENT="gpt-4.1"
```

### Step 6: Set Startup Command
```bash
az webapp config set \
  --resource-group rg-rag-app \
  --name rag-app-unique-id \
  --startup-file "gunicorn --bind=0.0.0.0 --workers=4 rag_app:app"
```

### Step 7: Enable Application Logging
```bash
az webapp log config \
  --resource-group rg-rag-app \
  --name rag-app-unique-id \
  --web-server-logging filesystem
```

### Step 8: Deploy via ZIP
```bash
# From project root directory
Compress-Archive -Path * -DestinationPath app.zip

az webapp deployment source config-zip \
  --resource-group rg-rag-app \
  --name rag-app-unique-id \
  --src app.zip
```

### Step 9: Get Web App URL
```bash
az webapp show \
  --resource-group rg-rag-app \
  --name rag-app-unique-id \
  --query "defaultHostName" -o tsv
```

### Step 10: Test Deployment
```bash
# Test home page
curl https://<web-app-url>/

# Test RAG endpoint
curl "https://<web-app-url>/ask?question=hotels+in+london"
```

### Step 11: Monitor Logs
```bash
az webapp log tail \
  --resource-group rg-rag-app \
  --name rag-app-unique-id
```

## Troubleshooting
- **500 errors**: Check logs in Step 11
- **Module not found**: Verify requirements.txt is at project root
- **Environment variables not loaded**: Restart Web App after setting config
- **Connection timeout**: Check Azure Search credentials in env settings

## Rollback to Previous Deployment
```bash
az webapp deployment slot list \
  --resource-group rg-rag-app \
  --name rag-app-unique-id
```
```

---

## **File 2: AGENTIC_WORKFLOW.md**

```markdown
# Agentic Workflow: Automated Web App Deployment

This document defines automated agent tasks for deploying the RAG app.

## Workflow Overview

```
┌─────────────────┐
│ Phase 1: Prep   │
└────────┬────────┘
         │
┌────────▼────────────┐
│ Phase 2: Azure Infra│
└────────┬────────────┘
         │
┌────────▼────────────┐
│ Phase 3: Configure  │
└────────┬────────────┘
         │
┌────────▼────────────┐
│ Phase 4: Deploy     │
└────────┬────────────┘
         │
┌────────▼────────────┐
│ Phase 5: Verify     │
└────────┴────────────┘
```

## Phase 1: Local Preparation
**Tasks**: Validate and prepare local environment
**Status**: Sequential (must complete before Phase 2)

### Task 1.1: Validate requirements.txt
- **Input**: `requirements.txt` file
- **Action**: Check if contains `gunicorn` and `waitress`
- **Output**: Pass/Fail with missing packages list
- **Condition**: If packages missing → Add them

### Task 1.2: Update rag_app.py
- **Input**: `rag_app.py`
- **Action**: Remove `debug=True` from app.run()
- **Output**: Modified file confirmation
- **Condition**: Only if debug mode detected

### Task 1.3: Test with Gunicorn
- **Input**: Project directory
- **Action**: Run `gunicorn --bind=0.0.0.0 --workers=1 rag_app:app`
- **Output**: Server starts successfully (HTTP 200 on /ask)
- **Condition**: Must succeed before Phase 2

### Task 1.4: Create deployment package
- **Input**: Project files
- **Action**: Create `.gitignore` entries, compress to ZIP
- **Output**: `app.zip` file ready
- **Condition**: Exclude `.env`, `.git`, `__pycache__`

---

## Phase 2: Azure Infrastructure Setup
**Tasks**: Create Azure resources
**Status**: Sequential (depends on Phase 1.4)
**Parallelizable**: Tasks 2.1 → 2.2 → 2.3 can chain in series

### Task 2.1: Create Resource Group
- **Input**: Resource group name, region
- **Variables**: 
  - `RG_NAME=rg-rag-app`
  - `REGION=eastus`
- **Action**: `az group create --name $RG_NAME --location $REGION`
- **Output**: Resource group ID
- **Condition**: Fail if RG already exists (use existing)

### Task 2.2: Create App Service Plan
- **Input**: RG from Task 2.1, plan name, SKU
- **Variables**:
  - `PLAN_NAME=plan-rag-app`
  - `SKU=B2` (Standard tier)
- **Action**: `az appservice plan create --name $PLAN_NAME --resource-group $RG_NAME --sku $SKU --is-linux`
- **Output**: Plan ID
- **Condition**: Depends on Task 2.1

### Task 2.3: Create Web App
- **Input**: Plan from Task 2.2, unique app name
- **Variables**:
  - `APP_NAME=rag-app-<timestamp>`
  - `RUNTIME=PYTHON:3.11`
- **Action**: `az webapp create --resource-group $RG_NAME --plan $PLAN_NAME --name $APP_NAME --runtime $RUNTIME`
- **Output**: Default hostname (e.g., `rag-app-12345.azurewebsites.net`)
- **Condition**: Depends on Task 2.2

### Task 2.4: Enable Managed Identity (Optional)
- **Input**: Web App from Task 2.3
- **Action**: `az webapp identity assign --resource-group $RG_NAME --name $APP_NAME`
- **Output**: Principal ID
- **Condition**: Skip if not using managed identity

---

## Phase 3: Configure Environment
**Tasks**: Set app configuration
**Status**: Sequential (depends on Phase 2.3)

### Task 3.1: Set Application Settings
- **Input**: Env variables from `.env`, App Name from Task 2.3
- **Variables** (from `.env`):
  - `SEARCH_SERVICE_ENDPOINT`
  - `SEARCH_SERVICE_QUERY_KEY`
  - `SEARCH_INDEX_NAME`
  - `AZURE_OPENAI_ENDPOINT`
  - `AZURE_OPENAI_KEY`
  - `AZURE_OPENAI_DEPLOYMENT`
- **Action**: `az webapp config appsettings set --resource-group $RG_NAME --name $APP_NAME --settings <all-vars>`
- **Output**: Confirmation of applied settings
- **Condition**: Depends on Task 3.0 (read env file)

### Task 3.2: Set Startup Command
- **Input**: App Name from Task 2.3
- **Action**: `az webapp config set --resource-group $RG_NAME --name $APP_NAME --startup-file "gunicorn --bind=0.0.0.0 --workers=4 rag_app:app"`
- **Output**: Confirmation
- **Condition**: Must be set before deployment

### Task 3.3: Enable Logging
- **Input**: App Name from Task 2.3
- **Action**: `az webapp log config --resource-group $RG_NAME --name $APP_NAME --web-server-logging filesystem`
- **Output**: Log configuration confirmed
- **Condition**: For debugging support

---

## Phase 4: Deploy
**Tasks**: Upload and deploy code
**Status**: Sequential (depends on Phase 3.2)

### Task 4.1: Deploy ZIP Package
- **Input**: `app.zip` from Task 1.4, App Name from Task 2.3
- **Action**: `az webapp deployment source config-zip --resource-group $RG_NAME --name $APP_NAME --src app.zip`
- **Output**: Deployment ID, status URL
- **Condition**: Depends on Tasks 1.4, 3.2

### Task 4.2: Wait for Deployment
- **Input**: Deployment ID from Task 4.1
- **Action**: Poll `az webapp deployment show` every 10 seconds until `provisioningState=Succeeded`
- **Output**: Deployment success confirmation
- **Timeout**: 5 minutes
- **Condition**: Must complete before Phase 5

---

## Phase 5: Verification
**Tasks**: Validate deployment
**Status**: Sequential (depends on Phase 4.2)

### Task 5.1: Get Web App URL
- **Input**: App Name from Task 2.3
- **Action**: `az webapp show --resource-group $RG_NAME --name $APP_NAME --query defaultHostName`
- **Output**: Full hostname URL
- **Condition**: Extract from Task 2.3 output or query

### Task 5.2: Test Home Page
- **Input**: URL from Task 5.1
- **Action**: `curl -s https://<url>/ | grep -q "RAG\|home"`
- **Output**: HTTP 200 + HTML content verified
- **Retry**: 3 attempts, 5-second delay
- **Condition**: Validates app is running

### Task 5.3: Test RAG Endpoint
- **Input**: URL from Task 5.1
- **Action**: `curl -s "https://<url>/ask?question=test" | grep -q "answer\|error"`
- **Output**: Valid JSON response with results
- **Condition**: Validates Azure Search integration

### Task 5.4: Check App Logs
- **Input**: App Name from Task 2.3
- **Action**: `az webapp log tail --resource-group $RG_NAME --name $APP_NAME | head -50`
- **Output**: Last 50 log lines
- **Condition**: Flag any ERROR or CRITICAL entries

### Task 5.5: Performance Check
- **Input**: App Name from Task 2.3
- **Action**: Monitor CPU, memory, request count
- **Output**: Health metrics (should be normal for new deployment)
- **Condition**: Alert if CPU > 80%

---

## Workflow Execution Matrix

| Phase | Task | Duration | Depends On | Can Parallel | Status |
|-------|------|----------|-----------|------------|--------|
| 1 | 1.1 | 30s | None | - | Sequential |
| 1 | 1.2 | 30s | 1.1 | No | Sequential |
| 1 | 1.3 | 60s | 1.2 | No | Sequential |
| 1 | 1.4 | 30s | 1.3 | No | Sequential |
| 2 | 2.1 | 30s | 1.4 | - | Can start |
| 2 | 2.2 | 30s | 2.1 | No | Sequential |
| 2 | 2.3 | 60s | 2.2 | No | Sequential |
| 2 | 2.4 | 30s | 2.3 | Yes | Optional |
| 3 | 3.1 | 30s | 2.3 | Yes (with 3.2) | Batch |
| 3 | 3.2 | 30s | 2.3 | Yes (with 3.1) | Batch |
| 3 | 3.3 | 30s | 3.2 | No | Sequential |
| 4 | 4.1 | 120s | 3.2 | - | Sequential |
| 4 | 4.2 | 300s | 4.1 | No | Sequential |
| 5 | 5.1 | 10s | 4.2 | - | Sequential |
| 5 | 5.2 | 30s | 5.1 | Yes | Parallel |
| 5 | 5.3 | 30s | 5.1 | Yes | Parallel |
| 5 | 5.4 | 30s | 5.1 | Yes | Parallel |
| 5 | 5.5 | 30s | 5.1 | Yes | Parallel |

**Total Estimated Time**: ~15 minutes (accounting for waits)

---

## Error Handling

### Task Failure Logic
- **Phase 1 failure**: Stop entire workflow
- **Phase 2 failure**: Rollback all Phase 2 resources, stop
- **Phase 3 failure**: Delete Web App (Task 2.3), stop
- **Phase 4 failure**: Check logs, retry up to 2 times, then stop
- **Phase 5 failure**: Notify but don't rollback (deployment exists)

### Retry Policies
- Network errors (timeout): Retry 3 times with exponential backoff
- Resource conflicts: Retry with new unique identifier
- Validation failures: Stop and report

### Rollback Strategy
```
If Phase 2.3+ fails:
  1. Keep Web App running (for debugging)
  2. Note all resource IDs
  3. Option: az group delete --name $RG_NAME (manual cleanup)
```

---

## Success Criteria
✅ Phase 1: All 4 tasks pass
✅ Phase 2: Web App created with unique URL
✅ Phase 3: All env vars set + startup command configured
✅ Phase 4: Deployment completes successfully
✅ Phase 5: All tests pass (5.2, 5.3), logs show no errors

---

## Example Execution Log
```
[14:30:00] Phase 1.1: Validating requirements.txt ✓
[14:30:05] Phase 1.2: Updating rag_app.py ✓
[14:30:10] Phase 1.3: Testing with Gunicorn ✓
[14:30:25] Phase 1.4: Creating deployment package ✓
[14:30:30] Phase 2.1: Creating Resource Group ✓ (ID: rg-rag-app)
[14:30:35] Phase 2.2: Creating App Service Plan ✓ (ID: plan-rag-app)
[14:31:00] Phase 2.3: Creating Web App ✓ (URL: rag-app-123456.azurewebsites.net)
[14:31:05] Phase 3.1/3.2: Configuring app settings ✓
[14:31:10] Phase 3.3: Enabling logging ✓
[14:31:15] Phase 4.1: Deploying ZIP package ✓ (Deployment ID: 12345)
[14:32:30] Phase 4.2: Waiting for deployment ✓
[14:32:35] Phase 5.1: Getting Web App URL ✓
[14:32:40] Phase 5.2/5.3/5.4/5.5: Running verification tests ✓
[14:32:50] ✅ DEPLOYMENT SUCCESSFUL
```
```

---

## Save These Files

Create these in your project root:
1. **WEBAPP_DEPLOYMENT.md** — Step-by-step manual deployment guide
2. **AGENTIC_WORKFLOW.md** — Agentic agent task breakdown for automation

