VER=`grep version package.json | egrep --only-matching "[0-9]+.[0-9]+.[0-9]+"`
VERS=(`echo $VER | tr '.' '\n'`)
VER_MAJOR=${VERS[0]}
VER_MINOR=${VERS[1]}
VER_PATCH=${VERS[2]}


FLG_PATCH=FALSE
FLG_MINOR=FALSE

while getopts mp OPT
do
  case $OPT in
    "m" ) FLG_MINOR=TRUE ;;
    "p" ) FLG_PATCH=TRUE ;;
  esac
done

echo "current: ${VER}"
if ${FLG_PATCH}; then
    NEW_VER=$VER_MAJOR.$VER_MINOR.`expr $VER_PATCH + 1`
elif ${FLG_MINOR}; then
    NEW_VER=$VER_MAJOR.`expr $VER_MINOR + 1`.$VER_PATCH
else
  NEW_VER=`expr $VER_MAJOR + 1`.$VER_MINOR.$VER_PATCH
fi
echo "new: ${NEW_VER}"

FLG_CANCEL=TRUE
read -p "ok? (Y/n): " yn
case "$yn" in
  [Y]*) FLG_CANCEL=FALSE;;
  *) ;;
esac

if ${FLG_CANCEL}; then
  echo Canceled
  exit 1
fi

sed -i '' -e "s/\"version\": \"$VER\"/\"version\": \"$NEW_VER\"/" package.json
git add package.json
git commit -m "Version up to $NEW_VER"
git tag $NEW_VER
git push origin $NEW_VER
npm publish ./
