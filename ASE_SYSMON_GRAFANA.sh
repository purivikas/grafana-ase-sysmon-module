#!/bin/sh 
############################################################################################################
### Version : 1.0
### Name    : ASE_SYSMON_GRAFANA.sh
### Created : 17 May 2017
### Author  : Vikas Puri
### Company :
### Usage   : ASE sysmon performance statistics upload into InfluxDB/Grafana 
###         : 
###########################################################################################################
###
###
###
###
###########################################################################################################




if [ $# -lt 2  ]
then
        echo " Error : Insufficent parameters "
        echo " ASE_SYSMON_GRAFANA.sh -instance ASENAME  -interval  01 "
        echo " -help      : Display help                                  "
        echo " -instance  : Source ASE name                                "
        echo " -interval  : sysmon execution : -interval <minutes interval> "
        exit
fi


###
### Loop Option
###

instance=""
interval=""
sysmonFlg="N"

for Option in $@
do

        if [ "${Option}" == "-help" ]  || [ "${Option}" == "-instance" ]  || [ "${Option}" == "-interval" ]
        then

                if [ "${Option}" == "-help" ]
                then
                 
		 echo " Help : ASE_SYSMON_GRAFANA.sh "
                 echo " ASE_SYSMON_GRAFANA.sh -instance ASENAME  -interval  01 "
                 echo " -help     : Display help                                  "
                 echo " -instance : Source ASE name                               "
                 echo " -interval : sysmon execution : -interval <minutes interval> "

                 exit

                fi

                if [ ${Option} == "-instance" ]
                then
                        instance=`echo $@ |awk '{ print substr($0,match($0,"-instance")+9) }'|cut -d'-' -f1|sed 's/ //g' `
                fi

                if [ ${Option} == "-interval" ]
                then
                        interval=`echo $@ |awk '{ print substr($0,match($0,"-interval")+9) }'|cut -d'-' -f1|sed 's/ //g' `
                        sysmonFlg="Y"
                fi


        fi
done

errorFlg="N"
eMailFlg="N"


###
### ASE DB
###

SYBASE=/apps/sybase/
SCRIPTS=/home/sybase/scripts
SYBASEVER=16_0
SYBASE_ASE=ASE-${SYBASEVER}
SYBASE_OCS=OCS-${SYBASEVER}

export SYBASE SYBASE_ASE SYBASE_OCS

. $SYBASE/SYBASE.sh

PATH=${PATH}:/usr/bin:/bin:/usr/sbin:/sbin:${SYBASE}/${SYBASE_ASE}/bin:${SYBASE}/${SYBASE_ASE}/install:${SYBASE}/${SYBASE_OCS}/bin

LD_LIBRARY_PATH=${SYBASE}/{$SYBASE_OCS}/lib:${SYBASE}/${SYBASE_OCS}/lib3p:${SYBASE}/${SYBASE_OCS}/lib3p64:${SYBASE}/${SYBASE_ASE}/lib:$LD_LIBRARY_PATH

export PATH LD_LIBRARY_PATH

DSQUERY=$instance
export DSQUERY


FULLDATE=`date +%Y%m%d_%H%M`
DATE=`date +%Y%m%d`


DbUser=sa
DbPass=frank009



###
### InfluxDB
###

InfluxInstance=localhost
InfluxPort=8086
InfluxDB=SybaseStats


###
### Location
###

scriptDir=/home/sybase/scripts
sourceDir=/dumps/${instance}/perfstats/

processedDir=/dumps/${instance}/perfstats/processed
if [ ! -d ${processedDir} ]
then
        mkdir -p ${processedDir}
fi

errorDir=/dumps/${instance}/perfstats/errors
if [ ! -d ${errorDir} ]
then
        mkdir -p ${errorDir}
fi


workDir=/tmp
workdataFile=${workDir}/$$.csv
worklogFile="${workDir}/ASE_SYSMON_GRAFANA.log"




echo " " > ${worklogFile}
echo "$(basename $0):Started :$(date '+%Y%m%d_%H%M')" |tee -a  ${worklogFile}


if [ "${sysmonFlg}" == "Y" ]
then

sysmonFile=${workDir}/sysmon.${DSQUERY}.$$

isql -U${DbUser} -P${DbPass} -S${DSQUERY} -w999 -o${sysmonFile} <<.EOF.
exec sp_sysmon "00:${interval}:00"
go
.EOF.

fi

###
### List of ASE Sysmon File (For Loop)
###
for fileName in $sysmonFile
do

###
### Sysmon log mining {AWK}
###

${scriptDir}/ASE_SYSMON_GRAFANA.awk $fileName > $workdataFile
ERROUT=$?
if [ ! ${ERROUT} -eq 0 ]
then
        echo "sysmon file error !:$fileName" >> ${worklogFile}
        errorFlg="Y"
        exit 1
fi



###
### InfluxDB Upload
###

curl -i -XPOST "http://${InfluxInstance}:${InfluxPort}/write?db=${InfluxDB}" --data-binary @${workdataFile}
ERROUT=$?
if [ ! ${ERROUT} -eq 0 ]
then
        echo "error in uploading file :${fileName}." >> ${worklogFile}
        mv ${fileName} ${errorDir}
        errorFlg="Y"
else
        echo "sucessfuly uploaded file :${fileName}." >> ${worklogFile}
        mv ${fileName} ${processedDir}
fi

done

echo "$(basename $0):Completed :$(date '+%Y%m%d_%H%M')" |tee -a ${worklogFile}

if [ !  errorFlg == "Y" ]
then
        rm  ${workdataFile}
        rm  ${worklogFile}      
fi

### End-of-File
