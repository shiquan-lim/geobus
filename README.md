# GEOBUS
A geospatial analytics application built to provide visual analysis of bus routes and density functions in Singapore

### Launching Application
Open a terminal shell and connect to the remote instance via
```
ssh -i geobushostinstance.pem ubuntu@ec2-54-179-162-24.ap-southeast-1.compute.amazonaws.com
```
Then go to the shiny server directory on the server machine and then ensure that the current project is the latest version.

```
cd /srv/shiny-server/geobus
git pull
```
Serve the project
```
sudo start shiny-server
```
