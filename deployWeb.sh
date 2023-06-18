#!/bin/bash
clean=false
path="../remempurr-web/"
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-d|--dev)
		path="/mnt/d/Workspace/Sync/web/kittkat-xyz/apps.kittkat.xyz/dev/apps/remempurr/"
		shift # past argument
		;;
		-c|--clean)
		clean=true
		shift # past argument
		;;
		-D|--deploy)
		path="/mnt/d/Workspace/Sync/web/kittkat-xyz/apps.kittkat.xyz/apps/remempurr/"
		shift # past argument
		;;
		*)
		shift # past argument
		;;
	esac
done

[ $clean == true ] && flutter clean
flutter pub get
flutter build web --web-renderer canvaskit
[ $clean == true ] && rm -fr $path
cp ./build/web $path -r
echo "Complete"
