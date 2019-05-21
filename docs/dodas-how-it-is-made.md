# DODAS: How it is made

## DODAS Architecture: Basic Concepts

DODAS has a highly modular architecture and the workflows are **highly customisable.** This is extremely valuable for a user because it is a key to the possibility of extending the already provided configuration with anything the user might need \(from software dependencies up to the integration of external services passing through the user tailored code management\)**.** This kind of flexibility is achieved thanks to the modularity of the overall system which is shortly described below.  
The major sub-services composing DODAS are: the INDIGO [Identity and Access Management](https://indigo-iam.github.io/docs/v/current/) \(IAM\) and [Token Translation Service](https://legacy.gitbook.com/book/indigo-dc/wattson/details) \(TTS\), [PaaS Orchestrator](https://legacy.gitbook.com/book/indigo-dc/indigo-paas-orchestrator/details) and [Infrastructure Manager](http://imdocs.readthedocs.io/) \(IM\). Those composition of services represents the so-called **PaaS Core Services** of DODAS.  
IAM is the OpenidConnect Authorization Server which has the crucial role to **authenticate the user** and to provide her/him with a OIDC token which in turn is used to delegate service to act on behalf of the user itself. While the user must register to the IAM-DODAS instance, a federated system supporting eduGAIN, the PaaS Orchestrator and/or IM are responsible to take care of the user request \(in form of a TOSCA template\) and prepare **a cluster for containers orchestration over the IaaS**. DODAS relies on Mesos for the container orchestration. The container orchestrator is meant as a layer where the end-users service can be executed.    
Regarding the PaaS Orchestrator and IM, both have the role of abstracting the underlying IaaSes and both of them support the same TOSCA language for input data description. There are differences among the two, and there are additional features \(with respect to the abstraction\) which are only supported by the PaaS Orchestrator. Concrete examples are:

* A user needs to access a multi cloud environment, which in principle could be a combination of both public and private provider \(hybrid model\), in this case  the Orchestrator guarantee a transparent management of the underlying IaaSes
* A user needs support to the elasticity meant as an elastic extension of cluster based on load, the PaaS Orchestrator provides the proper support thanks to the integration with [Clues](https://legacy.gitbook.com/book/indigo-dc/clues-indigo/details). 

On the other hand it is worth mentioning that using your own public or private cloud through the orchestrator requires some [registration steps](using-dodas-with-external-providers/), while the IM does not require any resource registration. 

## A high level view from the end user perspectives

DODAS from the user perspective is a service aiming at enabling an easy solution for the creation of a complex setup for a computational environment on any cloud based environment. In other words, DODAS aim is to make the process of generating intricate setups as easy as it is today creating a virtual machine on any IaaS: a one-click solution.   
The summary of the major added values of DODAS for a scientist is: 

* **To provide a complete abstraction of the underlying clouds**
* **To automate the virtual hardware provisioning and configuration**
* **To provide a cluster platform with a high level of self-healing** 
* **To guarantee setup and service customization to cope with specific requirements**  

More concretely "a complex setup" in this context means a **container orchestrator** \(e.g. Mesos\) on top of which there could be any framework which in turn manages the user service. The user service can be anything in principle, however DODAS provides two principal baselines ready to be used and to be possibly extended: a HTCondor batch system and a Spark cluster.    
Dealing with DODAS for a user means to configure and submit a TOSCA template. Several templates have already been developed, one per supported use case \(see [this section](getting-started/) for further details\) but, of course, it is worth to remark that the key value is that you can either extend any of them or create your own.    
For the sake of completeness the very first step before developing and / or using existing templates is to register, and this must be done through the [IAM-DODAS ](https://dodas-iam.cloud.cnaf.infn.it/login)service.   
Except the registration step there is nothing else which represents a pre-requisite DODAS specific. There are, of course, pre-requisites both if you are about to use the [CMS](getting-started/cms-recipe.md) and[ AMS](getting-started/ams-recipe.md) implementation of DODAS as well as if you are supposed to External IaaS \(read as some cloud different from the provided [Enabling Facility](the-enabling-facility.md)\), as explained[ here](using-dodas-with-external-providers/). 





