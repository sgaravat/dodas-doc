# BigData Platform

The DODAS workflow implemented for BiData has two autonomous 
components: an Apache Spark cluster and an Apache Hadoop cluster.

## Description

The two components available in DODAS for BigData are:

* Spark
* Hadoop

The first one allows you to access a cluster with Spark available and launch your tasks from a client inside the cluster.The second one gives you a Hadoop cluster where you can store and manage your data.

## Launching a DODAS instance of Spark

> This assumes you are now familiar with followings steps:
> * how to GET a token from IAM-DODA
> * Show to submit a TOSCA template (either with PaaS orchestrator or Infrastructure Manager)

You can get the basic CMS TOSCA template from here and submit it after a proper configuration. There input parameters to be set are explained below.

Cluster parameters:

* marathon_username: Admin username for accessing Marathon HTTP service [default: "admin"]
* marathon_password: Admin password for accessing Marathon HTTP service [default: 's3cret'][required]
* mesos_username: Admin username for accessing Mesos HTTP service [default: "admin"]
* mesos_password: Admin password for accessing Mesos HTTP service [default: "admin"]
* slave_num: Number of slave nodes in the cluster [default: 4][required]
* slave_cpus: Numer of CPUs for the slave node [default: 2][required]
* slave_mem: Amount of Memory for the slave node [default: 4 GB][required]
* master_cpus: Numer of CPUs for the master node [default: 2][required]
* master_mem: Amount of Memory for the master node [default: 4 GB][required]
* spark_mesos_flavor: [ apache-zeppelin, spark-dispatcher ] [default: 'spark-dispatcher']

Spark parameters:

* hdfs_uri: HDFS URI needed to configure Spark storage [default: '']
* spark_cores_max: The maximum amount of CPU cores to request for the application from across the cluster [default: '6']
* spark_executor_cores: The number of cores to use on each executor. [default: '1']
* spark_executor_mem: Amount of memory to use per executor process [default: '1 GB']
* spark_driver_mem: Amount of memory to use for the driver process, i.e. where SparkContext is initialized [default:'1GB']
* spark_driver_cores: Number of cores to use for the driver process [default: '1']
* spark_swift_auth_url: 'Keystone auth URL. E.g.: https://cloud.recas.ba.infn.it:5000/v2.0/tokens' [default: '']
* spark_swift_region: Swift region name [default: '']
* spark_swift_tenant: Swift tenant name [default: '']
* spark_swift_username: Swift user name [default: '']
* spark_swift_password: Swift user password [default: '']
* spark_swift_provider: Swift provider name [default: '']

Once the cluster has been created you should be able to access the Marathon and Mesos GUIs for management, debugging etc. Plus you will have a spark-dispatcher app already present on Marathon and a long time service name spark-tunnel.

Now you can access the cluster through the load balancer ip and send your jobs.

## Submitting a Spark application

Connect to the bastion as follow:

```bash
ssh admin@your_lb_ip -p 31042
```

> The default password is _passwd_

Now you can create an example program, like the following one written in python:

```python
#! -*- coding: utf-8 -*-
from __future__ import print_function

from operator import add
from random import random

from pyspark import SparkConf, SparkContext

# Configure your application
conf = SparkConf().setAppName("PiCalc")
# Executor parameters
conf.set('spark.executor.memory', '512m')
conf.set('spark.executor.cores', '1')
conf.set('spark.executor.cores.max', '4')
conf.set('spark.cores.max', '4')
# the default docker image to use as worker node
conf.set('spark.mesos.executor.docker.image', 'dodasts/mesos-spark:base')

# Spark Context
sc = SparkContext(conf=conf)

PARTITIONS = 4
_N_ = 100000 * PARTITIONS

# Define the pi function
def foo(_):
    x = random() * 2 - 1
    y = random() * 2 - 1
    return 1 if x ** 2 + y ** 2 <= 1 else 0


print("[My Spark Application] Start the calculus")
# Launch the application in parallel
count = sc.parallelize(range(1, _N_ + 1), PARTITIONS).map(foo).reduce(add)

print("[My Spark Application] Pi is roughly {}".format(4.0 * count / _N_))

# Exit Spark Context
sc.stop()

```

Now you can run your application with the following command:

```bash
spark-run test_pi.py
```


> You will be asked to insert your sudo password to start the application because to run Spark Tasks you have to be a sudo user