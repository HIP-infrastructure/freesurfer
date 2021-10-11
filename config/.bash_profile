# Change the value for FREESURFER_HOME if you have 
# installed Freesurfer into a different location

APP_VERSION=$(ls /usr/local/freesurfer/)

# Load the app specific .env file
[[ -s "$HOME/.env" ]] && source "$HOME/.env"
echo -e $FREESURFER_LICENSE > $HOME/license.txt

export FREESURFER_HOME=/usr/local/freesurfer/${APP_VERSION}
export FS_LICENSE=$HOME/license.txt
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

