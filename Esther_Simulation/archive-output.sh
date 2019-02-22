sourcepath=$1
archivename=$2

archivepath=$HOME/Projects/archive/$archivename

mkdir -p $archivepath
mkdir -p $archivepath/configs
mkdir -p $archivepath/outputs
mkdir -p $archivepath/logs

mv $sourcepath/configs $archivepath/configs
mv $sourcepath/outputs $archivepath/outputs
mv $sourcepath/logs $archivepath/logs