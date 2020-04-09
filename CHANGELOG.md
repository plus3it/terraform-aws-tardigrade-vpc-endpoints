## terraform-aws-tardigrade-vpc-endpoints Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 4.0.0

** Released**: 2020.04.09

**Commit Delta**: [Change from 3.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/3.0.0...4.0.0)

**Summary**:

*   Requires fully-spec'd objects for security-group rules (backwards incompatible)
*   Changes default ingress rule from the VPC CIDR to 0.0.0.0/0 (recommended that users pass more restrive rule)

### 3.0.0

** Released**: 2020.04.03

**Commit Delta**: [Change from 2.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/2.0.0...3.0.0)

**Summary**:

*   Uses `for_each` instead of `count` to gracefully handle changes in the list elements and ordering (backwards incompatible).
*   Adds support for Gateway endpoints (s3 and dynamodb)
*   Adds support for endpoints that can only be resolved by the `service_name` instead of the simple `service` name (E.g. sagemaker)

### 2.0.0

**Released**: 2019.11.1

**Commit Delta**: [Change from 1.0.2 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/1.0.2...2.0.0)

**Summary**:

*   Uses service names instead of interface names to identify vpc endpoints (backwards incompatible)
*   Adds support for creating a security group per vpc endpoint

### 1.0.2

**Released**: 2019.10.28

**Commit Delta**: [Change from 1.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/1.0.1...1.0.2)

**Summary**:

*   Pins tfdocs-awk version
*   Updates documentation generation make targets
*   Adds documentation to the test modules

### 1.0.1

**Released**: 2019.10.02

**Commit Delta**: [Change from 1.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/1.0.0...1.0.1)

**Summary**:

*   Update testing harness to have a more user-friendly output
*   Update terratest dependencies

### 1.0.0

**Released**: 2019.09.11

**Commit Delta**: [Change from 0.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/compare/0.0.0...1.0.0)

**Summary**:

*   Upgrade to terraform 0.12.x
*   Add test cases

### 0.0.0

**Commit Delta**: N/A

**Released**: 2019.08.21

**Summary**:

*   Initial release!
