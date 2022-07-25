if [ $USER == "root" ]; then
  echo "Cannot logout as root"
  return 0
fi

pkill -KILL -u $USER
