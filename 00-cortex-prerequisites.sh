#!/bin/bash
#######################################################################
##                                                                   ##
##  Google CLoud Cortex Data Foundations                             ##
##   - https://github.com/GoogleCloudPlatform/cortex-data-foundation ##
#######################################################################

# 2022-04-07 - To Do
# - go back and split source and deploy projects
# - considerations for VPC 

###################################
## Define Vairables Here         ##
###################################

source variables.inc 

########################################################################

# Crete Project & Attach Billing Account
gcloud projects create $PJID_TGT
gcloud config set project $PJID_TGT
gcloud beta billing projects link $PJID_TGT --billing-account=$BILLING_ACCOUNT

gcloud projects create $PJID_SRC
gcloud config set project $PJID_SRC
gcloud beta billing projects link $PJID_SRC --billing-account=$BILLING_ACCOUNT

# Service Account Name to Create (prefix)
SERVICE_ACCOUNT=service-account-cortex

projNum=`gcloud projects describe $PJID_SRC --format="value(projectNumber)"`
SA_FULL=${SERVICE_ACCOUNT}@${PJID_SRC}.iam.gserviceaccount.com

# Get Cloud Build Service account
CBSA=${projNum}@cloudbuild.gserviceaccount.com


# Enable Services
gcloud services enable bigquery.googleapis.com \
                       cloudbuild.googleapis.com \
                       composer.googleapis.com \
                       storage-component.googleapis.com \
                       cloudresourcemanager.googleapis.com --project=$PJID_SRC

gcloud services enable bigquery.googleapis.com --project=$PJID_TGT


# Create Service Acount and Assign Permissions

gcloud iam service-accounts create $SERVICE_ACCOUNT \
    --description="Service account for Cortex deployment" \
    --display-name="poc-cortex-service-account" \
    --project=$PJID_SRC

gcloud projects add-iam-policy-binding $PJID_SRC \
--member="serviceAccount:${SA_FULL}" \
--role="roles/cloudbuild.builds.editor"


##### this
gcloud iam service-accounts add-iam-policy-binding $SA_FULL --member=user:$SA_USER --role="roles/iam.serviceAccountTokenCreator"

gcloud projects add-iam-policy-binding $PJID_SRC --member=serviceAccount:$SA_FULL --role=roles/storage.objectCreator

gcloud projects add-iam-policy-binding $PJID_SRC --member=serviceAccount:service-${projNum}@gcp-sa-cloudbuild.iam.gserviceaccount.com --role=roles/storage.objectAdmin

##troubleshooting - serviceusage.services.use
gcloud projects add-iam-policy-binding $PJID_SRC --member=serviceAccount:$SA_FULL  --role=roles/storage.admin


# Create Storage Buckets
gsutil mb -l $LOCATION gs://${PJID_SRC}-dag
gsutil mb -l $LOCATION gs://${PJID_SRC}-log


### Add BQ permissions to  Cloud Build Service Account

gcloud projects add-iam-policy-binding $PJID_SRC --member=serviceAccount:$CBSA --role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding $PJID_SRC --member=serviceAccount:$CBSA --role=roles/bigquery.jobUser

gcloud projects add-iam-policy-binding $PJID_TGT --member=serviceAccount:$CBSA --role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding $PJID_TGT --member=serviceAccount:$CBSA --role=roles/bigquery.jobUser

## Crete BQ Datasets

# _DS_RAW -- in Source project
bq --location=$LOCATION mk \
--dataset \
--default_table_expiration 0 \
--description "Used by the CDC process, this is where the replication tool lands the data from SAP. "  \
${PJID_SRC}:${DS_RAW}

# _DS_CDC -- in Source project
bq --location=$LOCATION mk \
--dataset \
--default_table_expiration 0 \
--description "Dataset that works as a source for the reporting views, and target for the records processed DAGs." \
${PJID_SRC}:${DS_CDC}






## Prerequisite Complete ##

echo "Prerequisite Complete - Run Deployment Checker"
echo 
echo "https://github.com/GoogleCloudPlatform/cortex-data-foundation#check-setup"
