# AthleteX dApp UI

## Getting Started 🚀

<!-- Mnenomic -->
<!-- web lady wheat index recipe chunk urge boost hungry critic language crossnote: this mnemonic is not secure; don't use it on a public blockchain.
 -->
### Overview
Once the sprint ends, we start a process of cutting a release which will ship out new features, bug fixes, etc.

### Steps to cut a release

1. Make sure to run the command: 
```sh
flutter format --set-exit-if-changed lib test
```
This will make sure that all the latest changes are there
2. Switch to the develop branch using this command:
```sh
git checkout develop
```
3. Once on the develop branch, make sure to pull the changes using this command:
```sh
git pull
```
4. Once develop branch has the latest changes, we will need to create a branch from develop.
- To create a new branch run the command:
```sh
git checkout -b release/x.x.x
```
Where 'x.x.x' represents the version number (1.0.0, 1.1.1, 1.2.0, etc.)

5. Once you are on the new branch navigate to the pubspec.yaml file and update the version number
- When finished, save the file which will automatically run the command 
```sh
flutter pub get
```
Or open a new terminal and run the command manually
6. Once that is completed you can now navigate to github and create a pull request (PR)
- This PR will have the release branch point to main branch
- Actions will need to be completed and they need to pass in order to merge that branch into main
- Once the PR has been approved make sure to merge the branch to main
  - Note: DO NOT SQUASH AND MERGE THE BRANCH AS THIS WILL CAUSE ISSUES LATER ON
7. Once the PR has been merged in, you will create another PR that points main to develop branch
- Follow the same process as step 6
- Once the PR has been approved, merge it in to develop
  - Note: DO NOT SQUASH AND MERGE THE BRANCH
8. Navigate to the JIRA board and go to the release section and copy the release notes
9. Navigate back to GitHub and go to the release section
- You will want to create a new release and name is as vx.x.x where x.x.x is the version number
- Name the Release Title as 'Release vx.x.x
- check the box 'Set as a pre-release'
- click on the button 'Publish Release'
