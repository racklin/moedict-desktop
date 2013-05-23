# Whether to build for various platforms
BUILD_MAC=1
BUILD_WIN32=1
BUILD_LINUX=0

# Whether or not to bundle plugins (in the plugins/*/ folders) with the distribution packages
BUNDLE_PLUGINS=0

# Version of Gecko to build with
GECKO_VERSION="18.0"
GECKO_VERSION="29.0.1"

# Paths to Gecko runtimes
MAC_RUNTIME_PATH="`pwd`/xulrunner/XUL.framework"
WIN32_RUNTIME_PATH="`pwd`/xulrunner/xulrunner_win32"
LINUX_i686_RUNTIME_PATH="`pwd`/xulrunner/xulrunner_linux-i686"
LINUX_x86_64_RUNTIME_PATH="`pwd`/xulrunner/xulrunner_linux-x86_64"

# Whether to sign builds
SIGN=1

# OS X Developer ID certificate information
DEVELOPER_ID=replacemereplacemereplacemereplacemerepl
CODESIGN_REQUIREMENTS="=designated => anchor apple generic  and identifier \"org.foo.bar\" and ((cert leaf[field.0.0.000.123456.000.1.2.3] exists) or ( certificate 1[field.1.0.000.123456.000.1.2.3] exists and certificate leaf[field.2.0.000.123456.000.1.2.3] exists  and certificate leaf[subject.OU] = \"FOO123BAR1\" ))"

# Paths for Windows installer build
MAKENSISU='C:\Program Files (x86)\NSIS\Unicode\makensis.exe'
UPX='C:\Program Files (x86)\upx\upx.exe'
EXE7ZIP='C:\Program Files\7-Zip\7z.exe'

# Paths for Windows installer build only necessary for signed binaries
SIGNTOOL='C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Bin\signtool.exe'
SIGNATURE_URL='https://www.example.com/'

# If version is not specified on the command line, version is this prefix followed by the revision
DEFAULT_VERSION_PREFIX="1.0.0."
# Numeric version for OS X bundle
VERSION_NUMERIC="1.0.0"

# Directory for building
BUILDDIR="/tmp/xulapp-build-`uuidgen | head -c 8`"

# Module to build
MODULE="xulapp"

# Directory for unpacked binaries
STAGEDIR="$CALLDIR/staging"
# Directory for packed binaries
DISTDIR="$CALLDIR/dist"

# App name
APPNAME="Moe Dictionary"
PACKAGENAME="moe-dict.app"

# Packages url (used for update packaging)
PACKAGESURL="http://www.example.com/app/packages"

# Specifies the path to use for the application's profile, based within the user's application data directory
PROFILE="moe-dict"
