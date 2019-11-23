## gitlab_runner_upgrade.sh
GitLab Inc. releases new versions of GitLab-CI and Runner softwares. The detailed procedure of upgrading runners is explained [here](https://docs.gitlab.com/runner/install/linux-manually.html#update-1).

It becomes tedious to login to all runners and execute all commands to upgrade runner. So, the script [gitlab_runner_upgrade.sh](./gitlab_runner_upgrade.sh) is developed to automate this process.

The script comprises of below 6 parts:
1. Taking backup of current gitlab-runner binary.
2. Stopping gitlab-runner process.
3. Downloading new version of gitlab-runner.
4. Giving execute permissions to newly downloaded gitlab-runner binary.
5. Verfiying if newly downloaded version is not same to old version.
6. Starting gitlab-runner process.

The script will ask for confirmation to proceed to each consecutive step.

If any of the steps fail, the script will exit with exit status of 1. We can then manually troubleshoot the issue. Once, the issue is resolved, we can re-run the script from begining to upgrade runner. This won't affect the functionality of the script and the runner will be upgraded in second run.

The script is written in such a way that it'll produce the same output, no matter how many times we re-run it. This can be understood from the fact that even if no new version is available and still we run the script, the script will run and download the existent version and will display a message in the end stating that "no new version is available and will continue with same old version".

The script can be placed in `/root` directory of each runner. The backup of old version is being stored in `/root/gitlab-runner-backup` directory.
