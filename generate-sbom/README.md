# BP-TRIVY-STEP
A BP step to orchestrate trivy execution

## Setup
* Clone the code available at [BP-TRIVY-STEP](https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-TRIVY-STEP)
* Build the docker image
```
git submodule init
git submodule update

docker build -f generate-sbom/Dockerfile -t registry.buildpiper.in/trivy-generate-sbom:1.0 .

```
## Testing
This section will give you a walkthrough of how you can use this image to do various types of testing
Some of the global environment variables that control the behaviour of scanning
* SCAN_SEVERITY | Default - HIGH,CRITICAL | For possible values check documentation
* FORMAT_ARG | Default - html | For possible values check documentation
* OUTPUT_ARG | Default - trivy-report.html | Give any path as per your preference


### Docker Image Scan

Docker image scan will scan a docker image, this BP step can be used independently and with BuildPiper as well
If you want to use it independently you have to take care of below things
    * You have to set IMAGE_NAME env variable
    * You have to set IMAGE_TAG env variable
    * You have to mount /var/run/docker.sock
    * You have to set WORKSPACE env variable
    * You have to set CODEBASE_DIR env variable

* Do local testing via image only

* Debugging
```
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/src -e WORKSPACE=/ -e CODEBASE_DIR=src -e IMAGE_NAME="panuharshit/salary" -e IMAGE_TAG="1.0" -e FORMAT_ARG="cyclonedx" -e OUTPUT_ARG="sbom.cdx.json"  registry.buildpiper.in/trivy-generate-sbom:1.0 
```
## Reference 
* [Docs](https://aquasecurity.github.io/trivy/v0.32/docs/)
