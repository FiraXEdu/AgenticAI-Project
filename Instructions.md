
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
### 2. Create resource group "aiggthrg" , Storage account - aistgr456 Location "EASTUS"
### 3. Create a storage container (konseematravel) to store data 
### 4. Add data (folders collateral & reviews) with storage container(konseematravel)
-----------------------------------------
## Install dependencies
### 1.Install Python
### 2. Install req

## Setup AI Search Service
### 1. Create Azure AI search
Search Service name: travelsearchsvc
Resource Group: aiggthrg
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

## Configure Azure AI Search
### 1. Go to -> .env -> update SEARCH_SERVICE_ENDPOINT , SEARCH_SERVICE_QUERY_KEY, SEARCH_INDEX_NAME

## Create Azure AI Foundry
### 1. Goto Microsft Foundry -> Create foundy project
### 2. Goto Foundry Portal -> Model catalog
### 3. Explore Model Capabilities 
https://ai.azure.com/catalog
