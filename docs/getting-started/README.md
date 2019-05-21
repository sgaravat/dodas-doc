# Getting Started

DODAS provides two generic workflows already implemented ready to be used or extended. As example both CMS and AMS have been extended one of the two baseline implementations.   
In practice:  DODAS provides TOSCA Templates \(plus Ansible\) for: 

* **HTCondor Batch System,** which in turn can be: 
  * A complete and standalone HTCondor batch system \(BatchSystem as a Service\)
    * as such it includes all the HTCondor services: Schedd, Central Manager and executors \(startds\).
  * A HTCondor extension of a already existing Pool 
    * this is about pre configured HTCondor executors \(startd\) auto-join a existing HTCondor pool.   
* **BigData Platform** 
  * A Machine Learning as a Service. Currently this is about a Spark Framework which can be coupled with a HDFS \(either pre-existing or generated on demand\) for data ingestion. 



