#!/bin/sh
  
DATA_DIR=/opt/kingbase/data

# 如果挂载目录，这个会使目录赋权到kingbase
chown -R kingbase:kingbase ${DATA_DIR}
exec su kingbase /opt/kingbase/initdb.sh
