###################################
## Define Vairables Here         ##
###################################

## Projects to Create
# Project where the source dataset is and the build will run.
PJID_SRC=partarch-cortex-src-6

# Target project for user-facing datasets (reporting and ML datasets)
# If same projects, set to $PJID_SRC
PJID_TGT=partarch-cortex-tgt-6


## Billing Acount to link to Project
BILLING_ACCOUNT=017192-CE8991-53B11F

## User who will invoke Service Acount
SA_USER=jake.holmquist@kinandcarta.com

## Construct Variables ##
#Datasets
DS_CDC=CDC_PROCESSED
DS_RAW=RAW_LANDING

#_DS_REPORTING=
#<<BQ dataset where Reporting views are created, will be created if it does not exist>>,
DS_REPORTING=CORTEX_REPORTING

#_DS_MODELS=
#<<BQ dataset where ML views are created, will be created if it does not exist>>,
DS_MODELS=CORTEX_MODELS

#Region
#REGION=us-central1
LOCATION=US

# Service Account Name to Create (prefix)
SERVICE_ACCOUNT=service-account-cortex
