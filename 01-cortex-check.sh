#!/bin/bash 

#https://github.com/GoogleCloudPlatform/cortex-data-foundation#check-setup

PROJECT_ID=partarch-cortex-poc-6

#Clone checker repo
git clone  https://github.com/fawix/mando-checker

#cd into repo
cd mando-checker

#run the checker
gcloud builds submit \
   --project $PROJECT_ID  \
   --impersonate-service-account service-account-cortex@${PROJECT_ID}.iam.gserviceaccount.com \
   --substitutions _DEPLOY_PROJECT_ID=${PROJECT_ID},_DEPLOY_BUCKET_NAME=${PROJECT_ID}-dag,_LOG_BUCKET_NAME=${PROJECT_ID}-log .   
