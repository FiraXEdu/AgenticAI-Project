@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set values for your storage account
set subscription_id=your-subscription-id
set azure_storage_account=stkonaseema
set azure_storage_key=your-azure-storage-key


echo Creating container...
call az storage container create --account-name !azure_storage_account! --subscription !subscription_id! --name konaseema --auth-mode key --account-key !azure_storage_key! --output none

echo Uploading files...
call az storage blob upload-batch -d konaseema -s data --account-name !azure_storage_account! --auth-mode key --account-key !azure_storage_key!  --output none
