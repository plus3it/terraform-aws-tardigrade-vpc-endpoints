# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates VPC endpoints, both Gateway and Interface types, for a list of AWS services. The main inputs are `vpc_endpoint_services` (a list of service names and types) and `subnet_ids` (the VPC is taken from the first subnet); Interface endpoints get one shared security group, or one each when `create_sg_per_endpoint` is true, and Gateway endpoints attach to `route_table_ids`. It outputs the security groups, the Interface endpoints, and the Gateway endpoints as `vpc_endpoint_sgs`, `vpc_endpoint_interface_services`, and `vpc_endpoint_gateway_services`.
