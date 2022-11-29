#!/bin/bash

# https://github.com/GoogleCloudPlatform/cortex-data-foundation#deploy-the-data-foundation

# Clone the repo
git clone --recurse-submodules https://github.com/GoogleCloudPlatform/cortex-data-foundation

cd cortex-data-foundation


#########################
# Get Vriables

source ../variables.inc

projNum=`gcloud projects describe $PJID_SRC --format="value(projectNumber)"`
SA_FULL=${SERVICE_ACCOUNT}@${PJID_SRC}.iam.gserviceaccount.com

#########################################################################################

#_GCS_BUCKET=
#<<Bucket for logs - Cloud Build Service Account needs access to write here>>,
GCS_BUCKET=${PJID_SRC}-log

#_TGT_BUCKET=
#<<Bucket for DAG scripts - don’t use the actual Airflow bucket - Cloud Build Service Account needs access to write here>>,
TGT_BUCKET=${PJID_SRC}-dag

#_TEST_DATA=
#true,
TEST_DATA=true

#_DEPLOY_CDC=
#false
DEPLOY_CDC=true

######## Optional

#_LOCATION=
# Location where the BigQuery dataset and GCS buckets are (Options: US, ASIA or EU)
# LOCATION=US

#_MANDT=
# Default mandant or client for SAP. For test data, keep the default value.
#MANDT=

#_sql-flavor=
# S4 or ECC. See the documentation for options. For test data, keep the default value.
#sql-flavor=

###########################################################################################


gcloud builds submit --project $PJID_SRC --impersonate-service-account $SA_FULL --substitutions _PJID_SRC=$PJID_SRC,_PJID_TGT=$PJID_TGT,_DS_CDC=$DS_CDC,_DS_RAW=$DS_RAW,_DS_REPORTING=$DS_REPORTING,_DS_MODELS=$DS_MODELS,_GCS_BUCKET=$GCS_BUCKET,_TGT_BUCKET=$TGT_BUCKET,_TEST_DATA=$TEST_DATA,_DEPLOY_CDC=$DEPLOY_CDC
