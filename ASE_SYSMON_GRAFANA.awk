#!/usr/bin/awk -f

BEGIN {class="null";dbname="master";eventname="null";value=0}

/Server Name:/ { servername=$3 }
#/Sampling Ended at:/ { sub(/\,/,"T",$5);sub(/$/,"-",$6); sub(/$/,"-",$4);; datestamp=$6 $4 $5 } /Sampling Ended at:/ { sub(/\,/,"T",$5);sub(/$/,"-",$6); sub(/$/,"-",$4);sub(/Jan/,"01",$4);sub(/Feb/,"02",$4);sub(/Mar/,"03",$4);sub(/Apr/,"04",$4);sub(/May/,"05",$4);sub(/Jun/,"06",$4);sub(/Jul/,"07",$4);sub(/Aug/,"08",$4);sub(/Sep/,"09",$4);sub(/Oct/,"10",$4);sub(/Oct/,"11",$4);sub(/Dec/,"12",$4); datestamp=$6 $4 $5 } /Sampling Ended at:/ { timestamp=$7 } 

###############################################################
## Kernel Utilization
###############################################################
/Kernel Utilization/,/Worker Process Management/{


 	class="KernalUtilization";

         if ($1 == "ThreadPool" && NF == 3 )
         {      
                ThreadPool=$3 ;
         }

        # Engine Utilization
        subclass="EngineUtilization" ;

        if ($1 == "Engine" && NF == 10 && $2 != "Utilization" )
        {
	 eventname=$1$2;
         printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$3+$5;
        }

        # Average Runnable Tasks
        subclass="AverageRunnableTasks" ;

        if ($1 == "Engine" && NF == 7 && $2 != "Runnable" )
        {
		eventname=$1$2;
                printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }      

        # Thread Utilization (OS %)
        subclass="ThreadUtilizationOS" ;

        if ($1 == "Thread" && NF == 11 && $2 != "Utilization" )
        {
		eventname=$1$2;
                printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$6+$8;
        }      

        if ($1 == "Thread" && NF == 10 && $2 != "Utilization" )
        {
	 eventname=$1$2;
         printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$5+$7;
        }      

        if ($1 == "Thread" && NF == 9 && $2 != "Utilization" )
        {
	 eventname=$1$2;
         printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$4+$6;
        }      

        # Context Switches at OS

        subclass="ContextSwitchesatOS";

        if ($1 == "Voluntary" && NF == 6 && $2 != "Switches" )
        {
	 eventname=$1;
         printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$5;
        }      

        if ($1 == "Non-Voluntary" && NF == 6 && $2 != "Switches" )
        {
	  eventname=$1;
          printf "ase_kernel_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$5;
        }      

         # CtlibController Activity


         # DiskController Activity


         # NetController Activity               
        
}


###############################################################
## Worker Process Management
###############################################################
/Worker Process Management/,/Parallel Query Management/{

	 class="WorkerProcessManagement";
   
         subclass="WorkerProcess" ;

         #Worker Process Requests      
         if ($2 == "Requests" && NF == 6 && type != "Memory" )
         {
          eventname="WorkerProcessRequests";
          printf "ase_worker_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }
  
         #Worker Process Usage
         if ($2 == "Used" && NF == 6 )
         {
          eventname="WorkerProcessUsage";
          printf "ase_worker_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

         #Max Ever Used During Sample
         if ($1 == "Max" && NF == 9 )
         {
          eventname="MaxEverUsedDuringSample";
          printf "ase_worker_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$8;
                type="Memory" ;
         }
         
	 #Memory Requests for Worker Processes
         if ($2 == "Requests" && NF == 6 && type == "Memory" )
         {
          eventname="MemoryRequestsforWorkerProcesses";
          printf "ase_worker_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

       
}

###############################################################
## Parallel Query Management
###############################################################
/Parallel Query Management/,/Task Management/{

	 class="ParallelQueryManagement";

	 subclass="ParallelQuery";

         #Parallel Query Usage
         if ($2 == "Parallel" && NF == 7 )
         {
          eventname="ParallelQueryUsage";
          printf "ase_parallel_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }
       
         #Merge Lock Requests
         if ($4 == "Requests" && NF == 8  )
         {
          eventname="MergeLockRequests";
          printf "ase_parallel_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }

         #Sort Buffer Waits
         if ($4 == "Waits" && NF == 8  )
         {
          eventname="SortBufferWaits";
          printf "ase_parallel_process_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }
}

###############################################################
## Task Management
###############################################################
/Task Management/,/Application Management/{

	 class="TaskManagment";


         if ($1 == "ThreadPool" && NF == 3 )
         {      
                ThreadPool=$3
         }

         #Connections Opened
         if ($1 == "Connections" && NF == 6  )
         {
          eventname="ConnectionsOpened";
          printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }


         #Task Context Switches by Engine              
         subclass="TaskContextSwitchesbyEngine";
         if ($1 == "Engine" && NF == 10 )
         {
	 eventname=$1$2;	
         printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$3;
         }

        # Task Context Switches Due To
        subclass="TaskContextSwitchesDueTo";
        
	 if ($1 == "Voluntary" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $6 }
         if ($1 == "Cache"  ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Exceeding" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $8 }
         if ($1 == "System" ) { eventname=$1 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Logical" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Address" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Latch" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $6 }
         if ($1 == "Log" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "PLC" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Group" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Last" ) { eventname=$1$2$3$4 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $8 }
         if ($1 == "Modify" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $6 }
         if ($1 == "Device" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Network" && $3 == "Received" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Network" && $3 == "Sent" ) { eventname=$1$2$3 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7 }
         if ($1 == "Network" && $2 == "services" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $6 }
         if ($1 == "Other" ) { eventname=$1$2 ; printf "ase_task_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$6 }

}

###############################################################
## Application Management
###############################################################
/Application Management/,/ESP Management/ {


	class="ApplicationManagment";

         #Priority Changes

         subclass="PriorityChanges";

         if ($2 == "High" && NF == 8 )
         {
	 eventname="High";
         printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=high_count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

         if ($2 == "Medium" && NF == 8 )
         {
	 eventname="Medium";
         printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=medium_count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

         if ($2 == "Low" && NF == 8 )
         {
	 eventname="Low";
         printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=low_count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

         #Allotted Slices Exhausted

         if ( $2 == "Slices" && NF == 7 )
         {
          eventname="AllottedSlicesExhausted";
          printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }
       
       
         #Skipped Tasks By Engine

         subclass="SkippedTasksByEngine";

         if ( $1 == "Engine" && NF == 7 && $2 != "Scope" )
         {
	  eventname=$1$2;
          printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

         #Engine Scope Changes

         subclass="EngineScopeChanges";

         if ( NF == 7 && $2 == "Scope" )
         {
	  eventname=$1$2;
          printf "ase_application_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }
       

}

###############################################################
## ESP Management
###############################################################
/ESP Management/,/Housekeeper Task Activity/ {

	 class="ESPManagment";

         #ESP Requests
         if ( $1 == "ESP" && NF == 6 )
         {
         eventname="ESPRequests";
         printf "ase_esp_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

}

###############################################################
## Housekeeper Task Activity
###############################################################
/Housekeeper Task Activity/,/Monitor Access to Executing SQL/ {

	class="HousekeeperTaskActivity";

        # Buffer Cache Washes
        subclass="BufferCacheWashes";
         if ( $1 == "Clean" )
         {
	  eventname="Clean";
	  printf "ase_housekeep_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
         }

         if ( $1 == "Dirty" )
         {
	  eventname="Dirty";
          printf "ase_housekeep_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
         }

        # Garbage Collections
         subclass="GarbageCollections";

         if ( $1 == "Garbage" )
         {
	  eventname="Collection" ;
          printf "ase_housekeep_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

        # Pages Processed in GC

	 if ( $1 == "Pages" )
         {
	  eventname="PagesProcessedinGC";
    	  printf "ase_housekeep_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
	  }

        # Statistics Updates
       
	 if ( $1 == "Statistics" )
         {
	  eventname="StatisticsUpdates";
	  printf "ase_housekeep_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }
}


###############################################################
## Monitor Access to Executing SQL
###############################################################
/Monitor Access to Executing SQL/,/Transaction Profile/ {

	class="MonitorAccessToExecutingSQL";

	subclass="ExecutingSQL";

        # Waits on Execution Plans     
         if ( $1 == "Waits" )
         {
          eventname="WaitsonExecutionPlans";
          printf "ase_exesql_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }

        # Number of SQL Text Overflows
         if ( $1 == "Number" )
         {
          eventname="NumberofSQLTextOverflows";
          printf "ase_exesql_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$8;

         }

        # Maximum SQL Text Requested (since beginning of sample)
         if ( $1 == "Maximum" )
         {
          eventname="MaximumSQLTextRequested";
          printf "ase_exesql_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }

}


###############################################################
## Transaction Profile
###############################################################
/Transaction Profile/,/Transaction Management/ {

	class="TransactionProfile";

        subclass="TransactionDetails";

        # Committed Xacts
         if ( $2 == "Xacts" )
         {
         eventname="Committed";
         printf "ase_tranxprofile_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

        # Transaction Detail Inserts    
         if ( $3 == "Inserted" )
         {
         eventname="Inserts";
         printf "ase_tranxprofile_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }
       
        # Transaction Detail Updates
         if ( $3 == "Updated" )
         {
         eventname="Updates";
         printf "ase_tranxprofile_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

        # Transaction Detail Data Only Locked Updates
         if ( $2 == "DOL" )
         {
         eventname="DOLUpdates";
         printf "ase_tranxprofile_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }
       
        # Transaction Detail Deletes
         if ( $3 == "Deleted" )
         {
         eventname="Deletes";
         printf "ase_tranxprofile_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

}

###############################################################
## Transaction Management
###############################################################
/Transaction Management/,/Index Management/ {

}

###############################################################
## Index Management
###############################################################
/Index Management/,/Metadata Cache Management/ {

}



###############################################################
## Metadata Cache Management
###############################################################
/Metadata Cache Management/,/Lock Management/ {
class="MetadataCacheManagment";

        # Open Object Usage

        # Open Index Usage

        # Open Partition Usage

        # Open Database Usage

subclass="MetadataSpinlockContention";
}


# Object Manager Spinlock Contention
/Object Manager Spinlock Contention/    { eventname="ObjectManagerSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $8; }

# Object Spinlock Contention
/Object Spinlock Contention/            { eventname="ObjectSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7; }

# Index Spinlock Contention
/Index Spinlock Contention/             { eventname="IndexSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7; }

# Index Hash Spinlock Contention
/Index Hash Spinlock Contention/        { eventname="IndexHashSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $8; }

# Partition Spinlock Contention
/Partition Spinlock Contention/         { eventname="PartitionSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $7; }
 
# Partition Hash Spinlock Contention
/Partition Hash Spinlock Contention/    { eventname="PartitionHashSpinlockContention"; printf "ase_metadatacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname, $8; }



###############################################################
## Lock Management
###############################################################
/Lock Management/,/Data Cache Management/ {

}



###############################################################
##  Data Cache Management
###############################################################
/Data Cache Management/,/NV Cache Management/ {

        class="DataCacheManagment";

        if ( $1 == "Cache:" )
        {
             subclass=$2$3$4
        }
                       
         if ($3 == "Searches")
         {	
	 eventname="Searches";
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }

         if ($1 == "Spinlock")
         {
	 eventname="Spinlock";
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }

         if ($1 == "Utilization")
         {
	 eventname="Utilization";
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }
         if ($2 == "Hits")
         {
	 eventname="Hits";
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$6;
         }
         if ($3 == "Hits")
         {
	 eventname="AllCacheHits";
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }

        if (($1 == "8") || ($1 == "16") || ($1 == "64") || ($1 == "128") || ($1 == "256") )
        {
	subclass="PoolUtilization" ;
         eventname=$1$2;
        }
        if ($1 == "LRU")
        {
         printf "ase_datacache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=perc value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }

}
       


###############################################################
## Procedure Cache Management
###############################################################
/Procedure Cache Management/,/Memory Management/ {

	class="ProcedureCacheManagement";

        subclass="ProcedureCache";

         if ($2 == "Requests")
        {
	eventname="Requests";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }
         if ($2 == "Reads")
        {
	eventname="Reads";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }
         if ($2 == "Writes")
        {
	 eventname="Writes";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
         }
         if ($2 == "Recompilations")
        {
	 eventname="Recompilations";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $5;
         }

               
        #Recompilations Requests:

        #Recompilation Reasons:

        # SQL Statement Cache:

        subclass="SQLStatementCache";

         if ($2 == "Cached")
        {
	 eventname="Cached";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $5;
         }
         if ($2 == "Found")
        {
	 eventname="Found";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
         }
         if ($2 == "Dropped")
        {
	 eventname="Dropped";
         printf "ase_proccache_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $5;
         }

}


###############################################################
## Memory Management
###############################################################
/Memory Management/,/Recovery Management/ {
      
	class="MemoryManagement";
 
        subclass="MemoryPages";

        # Pages Allocated
         if ($2 == "Allocated")
        {
	 eventname="Allocated";
         printf "ase_memory_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $5;
         }

        # Pages Released
         if ($2 == "Released")
        {
	 eventname="Released";
         printf "ase_memory_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $5;
         }

}


###############################################################
## Procedure Cache Management
###############################################################
/Recovery Management/,/Disk I\/O Management/ {

	class="RecoveryManagement";

        # Checkpoints
        subclass="Checkpoints";
        if ($3 == "Normal")
        {
	 eventname="Normal";
         printf "ase_recovery_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
        }

        if ($3 == "Free")
        {
	 eventname="Free";
         printf "ase_recovery_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
        }

        if ($1 == "Avg")
        {
	 eventname="Avg";
         printf "ase_recovery_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $6;
        }

}



###############################################################
## Disk I/O Management
###############################################################
/Disk I\/O Management/,/Network I\/O Management/ {

	 class="DiskIOManagement";

         subclass="DiskIOsEngine" ;
         if ($1 == "Engine" && NF == 6 )
         {
	  eventname="OutStandingIO";
          printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
         }

        # I/Os Delayed by
        subclass="IOsDelayedby";
        if ( $1 == "Disk"  && $3=="Structures" )
        {
	 eventname="DiskStructure";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6 ;
        }

        if ( $1 == "Server"  && $2=="Config" )
        {
	 eventname="ServerConfig";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6 ;
        }

        if ( $1 == "Engine"  && $2=="Config" )
        {
	 eventname="EngineConfig";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6 ;
        }

        if ( $1 == "Operating"  && $2=="System" )
        {
	 eventname="OperatingSystem";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6 ;
        }

       
        # Total Requested Disk I/Os
        subclass="DiskIOs" ;

        if ( $2 == "Requested"  && $3=="Disk" )
        {
         eventname="Requested";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7 ;
        }

        # Total Completed Disk I/O's
        if ( $2 == "Completed"  && $3=="Disk" && NF==6 )
        {
         eventname="Completed";
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6 ;
        }


        # Device Activity Detail

        subclass="DeviceActivityDetail";

        if ( NF == 9  && $2 == "per")
        {
	    eventname=$1;
        }

        if ( $2 == "I/Os"  && NF==7 )
        {
         printf "ase_disk_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5 ;
        }
       

}


###############################################################
## Network I/O Management
###############################################################
/Network I\/O Management/,/Replication Agent/ {


	class="NetworkIOManagment";

        subclass="NetworkIO" ;

        if ( $4 == "Requests" )
        {
		eventname="Requests";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
        }
        if ( $3 == "Delayed" )
        {
		eventname="Delayed";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $6;
        }
        if ( $4 == "Rec'd" )
        {
		eventname="PacketReceived";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
        }
        if ( $3 == "Rec'd" && NF==6 )
        {
		eventname="BytesReceived";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $6;
        }

        if ( $4 == "Sent" )
        {
		eventname="PacketSent";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $7;
        }
        if ( $3 == "Sent" && NF==6  )
        {
		eventname="BytesSent";
                printf "ase_network_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname, $6;
        }
}


###############################################################
## Replication Agent
###############################################################
/Replication Agent/,/=============================== End of Report =================================/ {

        class="ReplicationAgent";

        if ( $2 == "Agent:" )
        {
                dbname=$3
        }
        if ( $2 == "Server:" )
        {
                subclass=$3
        }

        # Log Scan Summary

       
        if ( $3 == "Scanned" )
        {
		eventname="LogScanned";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }
        if ( $3 == "Processed" )
        {
		eventname="LogProcessed";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }


        # Log Scan Activity
        if ( $1 == "Updates" )
        {
		eventname="LogUpdates";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
        }
        if ( $1 == "Inserts" )
        {
		eventname="LogInserts";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
        }
        if ( $1 == "Deletes" )
        {
		eventname="LogDeletes";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,repserver,agent,$4;
        }
        if ( $2 == "Procedures" )
        {
		eventname="LogProcedures";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
        }
        if ( $1 == "DDL" )
        {
		eventname="LogDDL";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }
        if ( $1 == "Writetext" )
        {
		eventname="LogWritetext";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }
        if ( $1 == "Text/Image" )
        {
		eventname="LogTextImage";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }
        if ( $1 == "CLRs" )
        {
		eventname="LogCLRs";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
        }
        if ( $1 == "Checkpoints" )
        {
		eventname="LogCheckpoints";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$5;
        }
        if ( $2 == "Statements" )
        {
		eventname="LogStatements";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }


        # Transaction Activity

        # Log Extension Wait

        # Schema Cache

        # Forward Schema Lookups

        # Backward Schema Lookups



        # Truncation Point Movement
        if ( $1 == "Moved" )
        {
		eventname="LogMoved";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$4;
        }
        if ( $1 == "Gotten" )
        {
		eventname="LogGotten";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$6;
        }

        # Connections to Replication Server
       

        # Network Packet Information
        if ( $3 == "Bytes" )
        {
		eventname="LogBytes";
                printf "ase_repagent_mgmt_class,class=%s,subclass=%s,instance=%s,dbname=%s,event=%s,subevent=count value=%s\n",class,subclass,servername,dbname,eventname,$7;
        }

        # I/O Wait from RS
}

END{}


### END OF FILE
