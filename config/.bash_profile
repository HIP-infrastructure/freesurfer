# Change the value for FREESURFER_HOME if you have 
# installed Freesurfer into a different location

#only execute if ghostfs is mounted
if mount |grep -q GhostFS
then
  APP_VERSION=$(ls /usr/local/freesurfer/)

  # Load the app specific .env file
  [[ -s "$HOME/.env" ]] && source "$HOME/.env"
  echo -e $FREESURFER_LICENSE > $HOME/license.txt

  export FREESURFER_HOME=/usr/local/freesurfer/${APP_VERSION}
  export FS_LICENSE=$HOME/license.txt

  #mkdir -p $HOME/nextcloud/data/freesurfer_subjects
  #export SUBJECTS_DIR=$HOME/nextcloud/data/freesurfer_subjects
  mkdir -p $HOME/data/freesurfer_subjects
  export SUBJECTS_DIR=$HOME/data/freesurfer_subjects

  source $FREESURFER_HOME/SetUpFreeSurfer.sh
fi

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

