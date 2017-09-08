
ASE SYSMON GRAFANA

@author 	:	Vikas Puri
@Version	:	0.1



Description : ASE sysmon performance statistics upload into InfluxDB/Grafana


Files :



Sybase ASE-1504828109417.json - Grafan Dashboard required to be imported into Grafana.



ASE_SYSMON_GRAFANA.awk

ASE_SYSMON_GRAFANA.sh - Update following into script. 

###
### InfluxDB
###

InfluxInstance=localhost
InfluxPort=8086
InfluxDB=SybaseStats 


###
### Database 
###


DbUser=Database_UserName
DbPass=Password
