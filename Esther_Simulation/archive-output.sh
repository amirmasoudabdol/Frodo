sourcepath=$1
archivename=$2

archivepath=$HOME/Projects/archive/$archivename

mkdir $archivepath
mkdir $archivepath/configs
mkdir $archivepath/outputs
mkdir $archivepath/logs

mv $sourcepath/configs $archivepath/configs
mv $sourcepath/outputs $archivepath/outputs
mv $sourcepath/logs $archivepath/logs