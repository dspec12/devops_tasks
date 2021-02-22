# DevOps Tasks

## Build
* Dockerfile that performs a multistage build. In the build stage dependencies are installed, and the application is downloaded and verified. The artifacts are then copied into the final stage.
<br>
<br>

## Deploy
* Kubernetes yaml for a statefulset and supporting objects. Tied together with kustomize: https://kustomize.io/

* Yaml was verified with Kubeval: https://kubeval.instrumenta.dev/
```
cd deploy/
> kustomize build . | kubeval -
PASS - stdin contains a valid Service (litecoin-svc)
PASS - stdin contains a valid StatefulSet (litecoin-statefulset)

```
<br>
<br>

## Gitlab-CI
* Located in the root of this repo. Assumes the setup of the gitlab runner with docker-in-docker enabled. https://docs.gitlab.com/runner/install/kubernetes.html.
<br>
<br>

## Poormans Logrotate
* A Python script that will scan a specified directory for files with the .log extension. Logs that are over 300Mb in size, or 7 days old will be copied, compressed, and truncated to 0. The compressed tarballs will be deleted after 90 days. A virtual environment is not needed, as there are no third party imports. 

* You can use something like Flog: https://github.com/mingrammer/flog to generate test log files.
<br>
<br>

## Terraform
* Did not have enough free time to get to this. While I have used terraform in the past, it's been about a year, and I need to review some documentation.