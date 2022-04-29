# Security Agent Rules & Policies
This repository hosts Datadog-curated rules & policies for the security agent. There are two main types: [Compliance Policies](#compliance-policies) and [Workload Security Rules](#workload-security-rules).

## Compliance Policies
These policies, provided by Datadog, check configuration and state against specific compliance frameworks. Currently Datadog provides out of the box support for a number of CIS benchmarks. The Center for Internet Security (CIS) is a non-profit organization formed to "make the connected world a safer place by developing, validating, and promoting timely best practice solutions that help people, businesses, and governments protect themselves against pervasive cyber threats"[1](https://www.cisecurity.org/about-us/). These benchmarks are used through the security & compliance industries as a set of best practices.

### CIS Docker
These policies are provded by Datadog and map to the CIS Docker benchmarks. Docker is a common technology used for hosting, installing, and managing containers and container images.

### CIS Kubernetes
These policies are provided by Datadog and map to the CIS Kubernetes benchmarks. Kubernetes is "an open-source system for automating deployment, scaling, and management of containerized applications."[2](https://kubernetes.io/).

## Workload Security Rules
These rules probvided by Datadog collect runtime events from Linux hosts and containers. Out of the box rules are provided to collect events based on tactics and techniques from the MITRE ATT&CK framework[3](https://attack.mitre.org/). The types of events supported are:

### File Integrity Monitoring Events
File Integrity Monitoring (FIM) events are events generated based on interactions with files on a host or container. Any opens, modifications, creations, and deletion are supported. FIM events are collected with information about the file interacted with, the type of interaction, and the process that performed the interaction as context. FIM can be useful for both security & compliance use-cases, and is best known for it's role in the PCI compliance framework.
