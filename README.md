# MobSF CI
This repo contains all the is required to run [MobSF](https://github.com/MobSF/Mobile-Security-Framework-MobSF) in the CI.
MobSF is a security tool that can scan APK/IPA and report various security issues.
By running it in the CI, you can find those issues earlier, and fix them. To learn more about what it MobSF and what it can detect, checkout the [blog post](https://medium.com/@omerlh/how-to-continuously-hacking-your-app-c8b32d1633ad).

## Docker App
The easiest way to use this repo is by using [docker app](https://github.com/docker/app). Simply run:
```
docker-app render omerl/mobsf-ci:0.3.0 --set target_folder=<path to the folder that contains the APK> --set target_apk=<apk name> --set output_folder=<path to folder where the report will be written> | docker-compose -f - up --exit-code-from scan
```
To parse the report, use Glue - see in the next section how.

## Usage
* Clone the repo
* Create a folder named `target` in the root folder, and place the target there (e.g. `target/my_app.apk`).
* Run the tests using:
```
TARGET_PATH='target/<name of the target>' docker-compose up --build --exit-code-from scan
```
* Wait for the command to complete, it will take some time. When the command will be completed, checkout the report under `output/report.json`.
* Use [OWASP Glue](https://github.com/OWASP/glue) to process the report by running:
```
docker run -it -v $(pwd)/output:/app owasp/glue:raw-latest ruby bin/glue -t Dynamic -T /app/report.json --mapping-file mobsf --finding-file-path /app/android.json -z 2
```