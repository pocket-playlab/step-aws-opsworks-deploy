step-aws-opsworks-deploy
========================

A wercker step for deploying an app on an AWS OpsWork stack

# Prerequisite

You must run the pip install step to install the awscli. 
Include the following in your wercker.yml file.

```
deploy:
    steps:
        - pip-install
            packages_list: "awscli"
```

# Options

* `access_key_id` (mandatory) 						          Your AWS access key id
* `secret_access_key` (mandatory) 					        Your AWS secret access key
* `stack_id` (mandatory)							              Your OpsWorks stack id
* `app_id` (mandatory)                              Your OpsWorks app id


* `instance_id` (optional)                          Your OpsWorks instances id
* `default_region` (optional, default: us-east-1) 	AWS region
* `default_output` (optional, default: json)		    Default output


# Example

```
- aws-opsworks-deploy:
            access_key_id: <key>
            secret_access_key: <secretkey>
            default_region: us-east-1
            default_ouput: json
            stack_id: <stackid>
            app_id: <appid>
            instance_id: <instanceid>
```

# Changelog

## 0.0.1

- initial release

## 0.0.2

- Added some checks and logging

## 0.0.3

- Corrected variables format

## 0.0.5

- Working version
