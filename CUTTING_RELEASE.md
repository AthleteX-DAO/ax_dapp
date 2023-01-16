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
git fetch
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

5. Once you are on the new branch navigate to the ```pubspec.yaml``` file and update the version number
![image](https://user-images.githubusercontent.com/89420193/212748205-d0c9c8ef-d8da-4ab0-99c5-8d4abfe4a1de.png)
- When finished, save the file which will automatically run the command or open a new terminal and run the command manually
```sh
flutter pub get
```

6. Once that is completed you can now navigate to github and create a pull request (PR)
- This PR will have the release branch point to main branch

![image](https://user-images.githubusercontent.com/89420193/212748299-0e769892-9c97-4817-9729-e1de9e31ffff.png)
- Actions will need to be completed and they need to pass in order to merge that branch into main
- Once the PR has been approved make sure to merge the branch to main
  - Note: DO NOT SQUASH AND MERGE THE BRANCH AS THIS WILL CAUSE ISSUES LATER ON
  
  ![image](https://user-images.githubusercontent.com/89420193/212748367-ef456fa8-1828-4147-bda3-de730aef2a7c.png)
  
7. Once the PR has been merged in, you will create another PR that points main to develop branch

![image](https://user-images.githubusercontent.com/89420193/212748591-dd42c32c-7f1d-4d73-978e-69365acc7db9.png)
- Follow the same process as step 6
- Once the PR has been approved, merge it in to develop
  - Note: DO NOT SQUASH AND MERGE THE BRANCH
  
  ![image](https://user-images.githubusercontent.com/89420193/212748405-1cdd2d6b-746b-4e53-8cd9-cb94d41f7fc0.png)
  
8. Navigate to the JIRA board and go to the release section and copy the release notes

![image](https://user-images.githubusercontent.com/89420193/212748773-361a1930-1280-43e4-ac00-3af94fdd1c8b.png)


9. Navigate back to GitHub and go to the release section

- You will want to create a new release and name is as v1.0.0 or whatever the current version is

![image](https://user-images.githubusercontent.com/89420193/212748804-3ee26936-4530-45a5-9c37-60233fbcea0a.png)

- Name the Release Title as 'Release v1.0.0 or whatever the current version is

![image](https://user-images.githubusercontent.com/89420193/212748871-6a8cca7a-8c8e-4d56-9038-9573b3103008.png)

- check the box 'Set as a pre-release'

![image](https://user-images.githubusercontent.com/89420193/212748931-0f5d625b-edeb-4baa-9b22-4bc524de7913.png)

- click on the button 'Publish Release'

![image](https://user-images.githubusercontent.com/89420193/212748949-1dd06b51-5eba-421e-9110-6cc745fcbc72.png)

