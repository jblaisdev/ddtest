
#########################################################################################################################
# steps to use this overlay
# 1) copy the supplied zip file "ddtest-1.0.0.zip" from the "archive-file-target" folder to
#    somewhere readable on a UNC network share, for example: "//server/path/to/file/ddtest-1.0.0.zip".
# 2) alter the below PATH_ON_NETWORK variable to match that path
set(PATH_ON_NETWORK "//cortex/s/Development/Package/thirdparty-binaries/ddtest")

#########################################################################################################################
# SHA of the provided zip archive containing a single header file
set(ARCHIVE_SHA512 "6fc20f04b96261b220f4d81fadf911604e30a36a807e5a98e9bbbaead1d3a5cfeaa5aec41a80ebd50519dc868a27a7a15892aa0863708c4f58990d18c2c839bc")

vcpkg_download_distfile(ARCHIVE
  URLS file:${PATH_ON_NETWORK}/ddtest-1.0.0.zip
  FILENAME "ddtest-1.0.0.zip"
  SHA512 ${ARCHIVE_SHA512}
)

vcpkg_extract_source_archive(
	SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
	NO_REMOVE_ONE_LEVEL # do not remove top level of archive during extraction (e.g., include, lib, bin)
)

#########################################################################################################################
# nothing else; only testing call to vcpkg_download_distfile