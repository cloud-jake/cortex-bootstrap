#!/bin/bash 

#https://github.com/GoogleCloudPlatform/cortex-data-foundation#check-setup

#PJID_SRC=$PJID_SRC

source variables.inc

#Clone checker repo
git clone  https://github.com/fawix/mando-checker

#cd into repo
cd mando-checker

#run the checker
gcloud builds submit \
   --project $PJID_SRC  \
   --impersonate-service-account ${SERVICE_ACCOUNT}@${PJID_SRC}.iam.gserviceaccount.com --async \
   --substitutions _DEPLOY_PROJECT_ID=${PJID_SRC},_DEPLOY_BUCKET_NAME=${PJID_SRC}-dag,_LOG_BUCKET_NAME=${PJID_SRC}-log .   
