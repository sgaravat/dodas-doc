# HTCondor CMS Recipe

The DODAS workflow implemented for CMS has been designed in order to generate an ephemeral Tier\* WLCG compliant. 

## Prerequisites

In the basic implementation has been built on the following assumptions 

1. There is **no Computing Element**. Worker nodes \(HTCondor startd processes\) start up as a docker container over Mesos cluster, and auto-join the HTCondor Global-Pool of CMS
2. Data I/O is meant to rely on AAA xrootd read rule 
   1. although there is not technical limitation preventing the usage of local storages.
3. stage-out relies on a Tier site of CMS, e.g. INFN relies on TI\_IT\_CNAF. The result is something like this in the site local config  


   ```text
   url="trivialcatalog_file:/cvmfs/cms.cern.ch/SITECONF/T1_IT_CNAF/PhEDEx/storage.xml?protocol=srmv2"/>
   ```

This imply to accomplish with the following pre-requisites: 

* Requires Submission Infrastructure \(SI\) L2s authorization for Global-Pool access. In order to being authorized you must belong to the CMS Collaboration and provide a DN and CMS Site Name. SI will use these info to define the proper mapping in the match-maker. 
  * Get a DN from X.509 Certificate you can retrieve from the [Token Translation Service ](https://dodas-tts.cloud.cnaf.infn.it/).  1. Click to request a x509.  2. A pop-up window will allow you to download the certificate PEM file. At that point you should run  `openssl x509 -noout -in <certificate.pem> -subject` 3. and you will obtain something like  `subject= /C=IT/O=CLOUD@CNAF/CN=xxxxxxx@dodas-iam`
  * Define a name for your ephemeral CMS Site: e.g.  `T3_XX_Opportunistic_KK`
* If you want to be visible in the Dashboard \(this is ONLY true for the old-fashioned [Dashboard](http://dashboard.cern.ch/cms/)\) you need to notify the dashboard support team informing that you need the following mapping among Site Name and SyncCE  `Site Name == T3_XX_Opportunistic_KK  SyncCE == T3_XX_Opportunistic_KK`
  * NOTE : This is needed because DODAS does not deploy a cluster which relies on a Computing Element. 
  * You need to provide a job id to the CERN monitoring team.

## Long Running Services 

Once done all of this, you should be able to get this TOSCA template and configure everything as described in the template itself.  
The CMS template deploys the following services and components:   
- squid proxy  
- proxy cache   
- worker node \(HTCondor startd\)  
- cvmfs  
- cvmfs-check app    
- CMS Trivial File Catalogue

Docker image files are available [here](https://github.com/DODAS-TS).

## Launching a DODAS instance of HTCondor for CMS

{% hint style="info" %}
This assume you are now familiar with following steps:

1. how to GET a token from IAM-DODAS
2. how to submit a TOSCA template \(either with PaaS orchestrator or Infrastructure Manager\)
{% endhint %}

You can get the basic CMS TOSCA template from [here](https://github.com/indigo-dc/tosca-templates/blob/master/dodas/CMS-HTCondor-dodas.yaml) and submit it after a proper configuration. There input parameters to be set are explained below. THere are 3 sections and these are the mandatory parameters. For advanced usage there is more to be configured.   


1.  **Marathon and Mesos related configuration parameters**
   1.  **marathon\_username**: Admin username for Marathon GUI
   2.  **marathon\_password**: Admin password for for Marathon GUI
   3.  **mesos\_username**: Admin username for Mesos GUI
   4.  **mesos\_password**: Admin password for Mesos GUI
   5. **number\_of\_masters**: 
   6. **num\_cpus\_master**: 
   7. **mem\_size\_master**:
   8. **number\_of\_slaves**:
   9. **num\_cpus\_slave**:
   10. **mem\_size\_slave:**
   11. **number\_of\_lbs**:
   12. **num\_cpus\_lb**: 
   13. **mem\_size\_lb**:
   14. **server\_image**: Image for the Virtual Machine to be used. NOTE all the recipes are validated for Ubuntu Xenial.  
2. **IAM related configurations to enable the OIDC to X.509 certificate translation**
   1. **iam\_token**: The token string obtained as explained [here](recipe-for-impatient-users.md#2-token-management)
   2. **Iam\_client\_id**: This must be provided \(once\) by DODAS admins
   3. **iam\_client\_secret**: This must be provided \(once\) by DODAS admins

  
3. **CMS specific configurations** 
   1. **cms\_local\_site**: This is a name of the format T3\_XX\_Opportunistic\_KK. You decide this as explained [here](cms-recipe.md#prerequisites).
   2. **cms\_stageoutsite**: This must be either an already existing T1/2/3, or a new site you will register in the CMS computing system.  
   3. **cms\_stageoutprotocol**: this is the protocol you want to use, to be set accordingly with one of the options supported by the SITECONF related to the cms\_stageoutsite. 

Once the cluster has been created you should be able to access the Marathon and Mesos GUIs for management, debugging etc.

The very last step of the deployment is the start-up HTCondor startd process. If no errors are encountered the startds should join the HTCondor global pool automatically, and thus if matching happens HTCondor start executing payloads.   
At that point, most probably, you would like to submit some jobs with proper configuration to allow the matching. 

## Submitting CRAB jobs for DODAS CMS Site 

In order to submit CRAB jobs with proper classad parameters which guarantee the matching, you need to add this extra line in the configuration file of CRAB: 

```text
config.Debug.extraJDL = [ '+DESIRED_Sites="T3_XX_XY_KK"','+JOB_CMSSite="T3_XX_XY_KK"','+AccountingGroup="highprio.<YOUR_LXPLUS_LOGIN>"' ]
```

There is no any other change you need to do. 

Finally there is a basic Elastic Search monitoring system which can be used and extended to cope with user specific needs. This is detailed [here](../monitoring.md#monitoring-implementation).

