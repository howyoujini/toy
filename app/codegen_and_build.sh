if ! [ -x "$(command -v jshell)" ]; then
  echo "jshell 명령을 실행할 수 없습니다. OpenJDK 9 이상을 설치해주세요 !">&2
  exit 1
fi

if ! [ -x "$(command -v flutter)" ]; then
    echo "flutter 명령을 실행할 수 없습니다. Flutter SDK 를 먼저 설치해주세요 !">&2
    exit 1
fi

# Parameter 분석
BUILD_PHASE="$1"
if [ "$#" -eq 0 ]; then
  BUILD_PHASE="local"
fi

BUILD_PHASE=$(echo "$BUILD_PHASE" | awk '{print tolower($0)}')
if [ "$BUILD_PHASE" != "local" ] && [ "$BUILD_PHASE" != "alpha" ] && [ "$BUILD_PHASE" != "release" ]; then
  echo "Usage: $0 {local|alpha|release} <all|apk|appbundle|ipa|web>"
  echo ""
  echo "       첫번째 변수는 미지정시 'local' 로 기본 적용됩니다."
  exit 1
fi

# Step 0: 스크립트 실행경로 보존 -----------------------------------|
CURRENT_DIR=$(pwd)

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
BUILD_SCRIPT_PATH="$SCRIPT_PATH/buildScript"

cd "$SCRIPT_PATH"

#Step 1: Codegen 실행 -----------------------------------------|
jshell "$BUILD_SCRIPT_PATH/codegen_before_build.jshell" -R-Dargs="$BUILD_PHASE"

if [ "$?" -eq "1" ]; then
  echo "Codegen 실패! 오류 원인을 해결 후 스크립트를 다시 실행해주세요 !"
  exit 1
fi

#Step 2: Dart build runner 실행 -------------------------------|
flutter pub run build_runner build --delete-conflicting-outputs

if [ "$#" -ne 2 ]; then
    echo "Flutter build 를 중단합니다. 빌드하려면 스크립트 사용법을 참고하세요."
    echo ""
    echo "Usage: $0 {local|alpha|release} <all|apk|appbundle|ipa|web>"
    exit 0
fi

#Step 3: Flutter build 실행  ----------------------------------|
BUILD_FLAG_RELEASE=""
if [ "$BUILD_PHASE" = "release" ]; then
  BUILD_FLAG_RELEASE="--release"
fi

BUILD_TARGETS="$2"
if [ "$2" = "all" ]; then
    BUILD_TARGETS="apk appbundle ipa web"
fi

echo "$BUILD_TARGETS" | tr ' ' '\n' | while read -r TARTGET; do
  flutter build $TARTGET $BUILD_FLAG_RELEASE
done

cd "$CURRENT_DIR"