# MobSF CI
This repo contains all the is required to run [MobSF](https://github.com/MobSF/Mobile-Security-Framework-MobSF) in the CI.
MobSF is a security tool that can scan APK/IPA and report various security issues.
By running it in the CI, you can find those issues earlier, and fix them.

## Usage
* Clone the repo
* Create a folder named `target` in the root folder, and place the target there (e.g. `target/my_app.apk`).
* Run the tests using:
```
TARGET_PATH='target/<name of the target>' docker-compose up --build --exit-code-from scan
```
* Wait for the command to complete, it will take some time. When the command will be completed, checkout the report under `output/report.json`.