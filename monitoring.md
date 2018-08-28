# Monitoring

This section provides the description of the knobs and handles DODAS provide to the end user in order to implement its own monitoring.

* [Monitoring implementation](monitoring.md#monitoring-implementation)
* [Using DODAS monitoring backend](monitoring.md#using-dodas-monitoring-backend)
* [Using third party Elasticsearch endpoint](monitoring.md#using-third-party-elasticsearch-endpoint)
* [Create and deploy your own Beat or sensor](monitoring.md#create-and-deploy-your-own-beat-or-sensor)

## Monitoring implementation

DODAS deployments can be monitored sending system and docker metrics collected by a [metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/current/index.html) to a desired [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html) backend for monitoring both the cluster VMs and the containers running on them. Once store in Elasticsearch the information are accessible from plain REST calls or visual dashboards can be produced with dedicated tools such as [Kibana](https://www.elastic.co/guide/en/kibana/current/index.html) or [Grafana](http://docs.grafana.org/).

The [CMS recipe](getting-started/cms-recipe.md) already includes the deployment of a metricbeat sensor on each Mesos slave configured as [here](https://gist.githubusercontent.com/dciangot/69b61ff2bb1327b6485af88ac06c71ff/raw/). Two modules are used among the variety available: [system](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-module-system.html) and [docker](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-module-docker.html).

## Using DODAS monitoring backend

It is possible to store metrics in a ready-to-use infrastructure composed by an Elasticsearch instance and an associated Grafana server where users can log in through DODAS IAM authentication.

If you are interested in using these resource please contact the support team at dodas-support&lt;at&gt;lists.infn.it asking for the authorization. You will receive the credentials needed for pushing information from metricbeat to the DODAS Elasticsearch. More over a dedicate Grafana project will be created as well with you as administrator.

## Using third party Elasticsearch endpoint

To send metrics to your own server, you can simply change the following configuration parameters within the [CMS recipe](getting-started/cms-recipe.md)

```text
monitordb_ip:
  type: string
  default: "host:port"

elasticsearch_secret:  
  type: string
  default: "password"
```

N.B. default user is \`dodas\`, this will be configurable on next versions

## Create and deploy your own Beat or sensor

One can create its own beat to send customized metrics to Elasticsearch following this [guide](https://www.elastic.co/guide/en/beats/devguide/current/new-beat.html). Once the beat is ready and compiled one can create a docker container with the beat binary inside to orchestrate the distribution inside the cluster as a Marathon app. 

If you prefer python over the golang beat approach, just create your own daemon pushing json documents in elasticsearch [one by one](https://elasticsearch-py.readthedocs.io/en/master/api.html#elasticsearch.Elasticsearch.create) or if you expect a big amount of docs each polling cycle push them in [bulk](https://elasticsearch-py.readthedocs.io/en/master/api.html#elasticsearch.Elasticsearch.bulk).

