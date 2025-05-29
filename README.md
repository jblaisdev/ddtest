Sample Visual Studio project that can be used to replicate an issue with vcpkg_download_distfile and an archive file on a local network UNC path. While this project points to a port in a companion vcpkg repository that contains a single test port (https://github.com/jblaisdev/vcpkg-ddtest.git), an overlay port is also supplied so builds can easily be tested in other network environments.

To test this, you will have to have access to a network store that can be accessed via UNC filepaths such as "file://server/path/to/file.zip". A sample zip archive with a single header is included in this project, or you can provide your own.

In order to verify a new and clean environment, Windows Sandbox was used for these tests. The following steps can be followed to replicate the issue:

1. Start a new instance of Windows Sandbox
2. Download and install VS2022 Pro Trial (https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Professional&channel=Release&version=VS2022&source=VSLandingPage&cid=2030&passive=false)
   * Select the Desktop development with C++ Workload, add "C++/CLI support for v143 build tools, and install
   * Hit Continue to ignore the "Operating system not supported" message if inside Windows Sandbox
   * You can Skip and add accounts later (MS/Github accounts not needed)
4. When prompted: "Clone a repository" -> https://github.com/jblaisdev/ddtest.git
5. Type "x64" in the windows start menu to open "x64 Native Tools Command Prompt for VS 2022"
   * Inside the prompt: "vcpkg integrate install"
7. Copy the supplied zip archive from the cloned repository (archive-file-target/ddtest-1.0.0.zip) to any local network store. Alternatively, you can create your own zip archive to use.
   * Make sure you can access the file via windows explorer: file://server/path/to/ddtest-1.0.0.zip -- you may need network credentials first.
9. Open the "overlays/ddtest/portfile.cmake" file and make the following change(s):
   * Alter the PATH_ON_NETWORK variable to match whever you stored the archive file in step (4). Note that is should *not* contain the zip filename, only the path.
   * If you chose to use your own zip archive file, alter the ARCHIVE_SHA512 variable to match the SHA of your file.
   * The supplied port overlay does define NO_REMOVE_ONE_LEVEL during vcpkg_extract_source_archive; remove that if you chose to use your own zip archive file and it contains a top level directory.
10. Build the ddtest project.

You should see the following error:
```
Downloading file://whatever/network/path/you/used/ddtest-1.0.0.zip -> ddtest-1.0.0.zip
create_directories(""): The system cannot find the path specified.
CMake Error at scripts/cmake/vcpkg_download_distfile.cmake:136 (message):
  Download failed, halting portfile.
Call Stack (most recent call first):
  C:/Users/WDAGUtilityAccount/source/repos/ddtest/overlays/ddtest/portfile.cmake:13 (vcpkg_download_distfile)
  scripts/ports.cmake:203 (include)
```

If you then open this file:
    C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\vcpkg\scripts\cmake\vcpkg_download_distfile.cmake
And change **arg_FILENAME** to **downloaded_file_path** on line 117, as shown here:
    https://github.com/microsoft/vcpkg/compare/master...jblaisdev:vcpkg:master
And then rebuild the project, the download should succeed.
