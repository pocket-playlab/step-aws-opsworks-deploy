#!/bin/bash

set -e

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_ACCESS_KEY_ID" ]
then
	error 'Please specify access key id'
	exit 1
else
	export AWS_ACCESS_KEY_ID=$WERCKER_AWS_OPSWORKS_DEPLOY_ACCESS_KEY_ID
fi

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_SECRET_ACCESS_KEY" ]
then
	error 'Please specify secret access key'
	exit 1
else
	export AWS_SECRET_ACCESS_KEY=$WERCKER_AWS_OPSWORKS_DEPLOY_SECRET_ACCESS_KEY
fi

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_STACK_ID" ]
then
	error 'Please specify stack id'
	exit 1
else
	export DEPLOY_STACK_ID=$WERCKER_AWS_OPSWORKS_DEPLOY_STACK_ID
fi

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_APP_ID" ]
then
	error 'Please specify app id'
	exit 1
else
	export DEPLOY_APP_ID=$WERCKER_AWS_OPSWORKS_DEPLOY_APP_ID
fi

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_DEFAULT_REGION" ]
then
	export AWS_DEFAULT_REGION='us-east-1'
else
	export AWS_DEFAULT_REGION=$WERCKER_AWS_OPSWORKS_DEPLOY_DEFAULT_REGION
fi

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_DEFAULT_OUTPUT" ]
then
	export AWS_DEFAULT_OUTPUT='json'
else
	export AWS_DEFAULT_OUTPUT=$WERCKER_AWS_OPSWORKS_DEPLOY_DEFAULT_OUTPUT
fi


if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_INSTANCE_ID" ]
then
	echo "Deploying on all instances"
	aws opsworks create-deployment --stack-id $DEPLOY_STACK_ID --app-id $DEPLOY_APP_ID --command "{\"Name\":\"deploy\"}"
else
	echo "Deploying on specified instances"
	aws opsworks create-deployment --stack-id $DEPLOY_STACK_ID --app-id $DEPLOY_APP_ID --instance-ids $WERCKER_AWS_OPSWORKS_DEPLOY_INSTANCE_ID --command "{\"Name\":\"deploy\"}"
fi

