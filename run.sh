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

cd $WERCKER_STEP_ROOT
apt-get install mozjs
curl -L http://github.com/micha/jsawk/raw/master/jsawk > jsawk
chmod 755 jsawk

if [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_INSTANCE_ID" ]
then
	echo "Deploying on all instances"
	aws opsworks create-deployment --stack-id $DEPLOY_STACK_ID --app-id $DEPLOY_APP_ID --command "{\"Name\":\"deploy\", \"Args\":{\"migrate\":[\"true\"]}}"
elif [ ! -n "$WERCKER_AWS_OPSWORKS_DEPLOY_LAYER_ID"]
then
	echo "Deploying on specified layer"
	aws opsworks describe-instances --layer-id 798ff890-ed75-41aa-a104-7297be8f1865|jsawk 'return this.Instances'|jsawk 'return this.InstanceId'
	
	aws opsworks create-deployment --stack-id $DEPLOY_STACK_ID --app-id $DEPLOY_APP_ID --command "{\"Name\":\"deploy\", \"Args\":{\"migrate\":[\"true\"]}}"
else
	echo "Deploying on specified instances"
	aws opsworks create-deployment --stack-id $DEPLOY_STACK_ID --app-id $DEPLOY_APP_ID --instance-ids $WERCKER_AWS_OPSWORKS_DEPLOY_INSTANCE_ID --command "{\"Name\":\"deploy\", \"Args\":{\"migrate\":[\"true\"]}}"
fi

