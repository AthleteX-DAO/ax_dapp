# AthleteX dApp UI

## Cutting a Release

### Overview
Cutting a release is a process where new features, bug fixes, etc. are shipped to production.
Whether they are features or general fixes, it is important to continuously ship these changes while working 
on the codebase. This document lists the steps needed to cut a new release.
### How to cut a release

1. First, make sure you are in the correct repository (```AthleteX-DAO/ax_dapp```) and run the command:
```sh
git fetch
```
- Running this command will download commits, files, and refs from a remote repository into your local repository

2. Switch to the ```develop``` branch using the command below:
```sh
git checkout develop
```

3. Once on the ```develop``` branch, make sure to pull the changes using this command:
```sh
git pull
```

- Running this command will download the content from the remote branch and update the local branch to match that conent.

4. Once develop branch has the latest changes, we will need to create a branch from develop.
- To create a new branch run the command:
```sh
git checkout -b release/x.x.x
```
Where ```x.x.x``` represents the version number (1.0.0, 1.1.1, 1.2.0, etc.) 

5. Once you are on the new branch navigate to the ```pubspec.yaml``` file and update the version number to the new version
![image](https://user-images.githubusercontent.com/89420193/212748205-d0c9c8ef-d8da-4ab0-99c5-8d4abfe4a1de.png)
- When finished, save the file which will automatically run the ```flutter pub get``` command or open a new terminal and run the command manually
```sh
flutter pub get
```

6. Once that is completed go to github and create a pull request (PR) 
- This PR will have the release branch point to ```main``` branch

![image](https://user-images.githubusercontent.com/89420193/212748299-0e769892-9c97-4817-9729-e1de9e31ffff.png)
- GitHub actions will be executed and they need to pass all checks
- Request a review from a developer so they can approve it
- Once the PR has been approved make sure to merge the branch to main
  
  ![image](https://user-images.githubusercontent.com/89420193/212748367-ef456fa8-1828-4147-bda3-de730aef2a7c.png)
  
7. Once the PR has been merged in, create another PR that points ```main``` to ```develop``` branch

![image](https://user-images.githubusercontent.com/89420193/212748591-dd42c32c-7f1d-4d73-978e-69365acc7db9.png)
- Just like with step 6, GitHub actions will be executed and they need to pass all checks
- Request a review from a developer so they can approve it
- Once the PR has been approved, merge it in to develop
  
  ![image](https://user-images.githubusercontent.com/89420193/212748405-1cdd2d6b-746b-4e53-8cd9-cb94d41f7fc0.png)
  
- Important note here: Please **do not** squash and merge the PR in as this will cause issues later on when cutting the release 
  
8. Navigate to the JIRA board and go to the ```Releases``` section and copy the release notes

- Make sure to select ```Markdown``` when copying to the clipboard

![image](https://user-images.githubusercontent.com/89420193/212748773-361a1930-1280-43e4-ac00-3af94fdd1c8b.png)


9. Go back to GitHub and go to the ```Releases``` section 

- Click on ```create a new release```

![image](https://user-images.githubusercontent.com/89420193/212748804-3ee26936-4530-45a5-9c37-60233fbcea0a.png)

- Create a new release tag with the new version number and name the title with as ```Release new_version_number```

![image](https://user-images.githubusercontent.com/89420193/212748871-6a8cca7a-8c8e-4d56-9038-9573b3103008.png)
![image](https://user-images.githubusercontent.com/89420193/212749552-39e0d676-3910-45ad-8271-3a9b104da5bd.png)

- In the text box section, paste the release notes that you have copied to the clipboard from step 8

![image](https://user-images.githubusercontent.com/89420193/212787868-6182516c-2171-4611-8ebb-49b9ef3f05e6.png)

- check the box ```Set as a pre-release```

![image](https://user-images.githubusercontent.com/89420193/212748931-0f5d625b-edeb-4baa-9b22-4bc524de7913.png)

- click on the button ```Publish release```

![image](https://user-images.githubusercontent.com/89420193/212748949-1dd06b51-5eba-421e-9110-6cc745fcbc72.png)

