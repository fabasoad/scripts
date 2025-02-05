# Organize photos

> :information_source: Supported OS: macOS

[Script](../src/organize-photos.sh) to organize and group photos and videos from
iPhone per folders based on dates. It is needed for easily uploading them to the
cloud.

## How to use

1. Plugin iPhone into macbook via cable.
2. Trust devices on both iPhone and macbook.
3. Open `Preview` application (Cmd+Space -> type `Preview`).
4. In `Preview` application go to `File` -> `Import from <iPhone name>`.
5. Once screen with all the photos and videos opened click on `Import All` button
   in the bottom right corner.
6. Choose the folder (it is better to create a new folder for these files).
7. Wait until it is done (all imported photos will be opened one by one, just wait
   until it is finished).
8. Once it is finished, close `Preview` application and unplug iPhone from macbook.
9. Open terminal and run the commands below.

   ```shell
   cd scripts/src
   ./organize-photos.sh <Path to the folder with photos and videos>
   # You should see logs with the information of each moved file
   ls -la <Path to the folder with photos and videos>
   # Be sure that you do not see any photos and videos here but "YYYY.MM.DD"
   # folders only
   ```
