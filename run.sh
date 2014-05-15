#!/bin/bash

if ! type aws &> /dev/null
then
	echo "aws is installed"
else
	echo "awscli is not installed"
fi