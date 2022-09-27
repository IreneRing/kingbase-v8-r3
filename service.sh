docker run -d --name kingbase-v8r3 -p 54321:54321 \
	-e SYSTEM_USER=kingbase -e SYSTEM_PWD=qwe123 \
	-v $(pwd)/volumes/opt/data:/opt/kingbase/data \
       	-v $(pwd)/volumes/opt/license.dat:/opt/kingbase/Server/bin/license.dat \
       	--restart=always  kingbase:v8r3
