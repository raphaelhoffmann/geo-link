read -p "WARNING: Script will erase sentences in database. Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit
fi

dropdb geo
deepdive initdb
deepdive run
