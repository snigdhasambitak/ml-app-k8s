# ml-app-k8s
A sample ML app that trains a model and we deploy it to k8s


The project contains a `ml app` Machine Learning application, and the docker configuration to run it
locally or deploy it on k8s platform.


## understanding project structure and files

* The `root` directory of the project contains the following files
  * `ml-app-k8s` folder that contains all the spring boot code base
    * `charts` folder contains helm chart files.
      * `templates` folder contains the following:
        * `deployment.yaml` contains K8s deployment specifics and env level variables.
        * `hpa.yaml` is used to specify auto-pod scaling in the cluster
        * `NetworkPolicy.yaml` file manages external access to the services in a cluster, typically HTTP.
        * `pdb.yaml` file is used to manage Pod Distribution Budget that the cluster will honor
        * `service.yaml` specifies service management like the loadbalancer with AWS
        * `cronjob.yaml` CronJob manifest prints the current time and a simple hello message every 5 minute
      * `chart.yaml` is used to specify app-pod level information that is used throughout the K8s config
      * `values.yaml` is used to handle app information and specifics. we can use `values/dev.yaml`
      to override these values and use them for each environment.
  * `core` folder is used to importing the packages we need, as well as the classes, which will be used to train our models
  * `data` folder is used to contain the datasets based out of [Auto MPG dataset](https://archive.ics.uci.edu/ml/datasets/auto+mpg) which is used for deploying a machine learning model
  * `models` folder contains the model which is dumped and exported to a file, that we can load into Python at another point in time
  * `main.py` contains the code to expose the model as a service
  * `train.py` contains the code to train our model by specifying which feature we want to predict
  * `Dockerfile` is the dockerfile used to build the image and/or run the app


## docker build

To run this project locally, please ``cd`` to the location this template is present and run the
following:

    docker docker build --tag ml-app .
    docker run -p 8080:8080 -itd ml-app:latest

## deploy the service using HELM

deploy the application to your kubernetes cluster using HELM.

```
kubectl config set-context `clusterName` --namespace `namespace`

cd chart/ml-app

helm upgrade ml-app .

```

## fetch the services info

now lets fetch the external or internal endpoint of the service that is deployed

```
kubectl get svc
```

## Making A Request To Our Application

We have the external-ip from earlier, which we are going to reuse here. The following JSON request can now be sent as with a HTTP POST method, and we will receive the expected response.

{
    "cylinders": 8,
    "displacement": 307.0,
    "horsepower": 130.0,
    "weight": 3504,
    "acceleration": 12.0,
    "model_year": 70,
    "origin": 1,
    "car_name": "chevrolet chevelle malibu"
}

In just `0.29` seconds, we received the prediction of this car, and our machine learning model predicted 16.383.
