* Coding Challenge - DevOps Engineer

We currently have a fleet of multiple development vehicles around the world that are required to be constantly connected to a complex backend. These vehicles upload telemetry as well as use-case specific data (eg: could be images, videos, sensor raw data, others...) depending on a client that is running in the cars and initiates these uploads. 
This data needs to be stored and processed in a way that allows for Data scientists and Machine learning engineer to get access to in an easy and efficient fashion.  

** Requirements

- Write a terraform script that provisions an Azure Kubernetes cluster, a load balancer configured to expose a configurable port and a storage account that is accessible from within the Kubernetes cluster. What are things to watch out for? How would you run the commands on a factory resetted Ubuntu computer?
- How would you add GPU nodes to the cluster?

Solution: [wiki here](./src/azure/terraform/README.md)
* What are things to watch out for? 
    * State file should be secured in a backend, in this project it is saved locally. 
    * Secrets credentails should be secured in my Secret Manager
    * Workspaces should be preferred to use to create parallel environments using terraform 
* How would you run the commands on a factory resetted Ubuntu computer?
    * We can use a docker container of ubuntu and mount the working directory, install all the tools(terraform, az cli) and run scripts.

- Write a Yaml (or Helm Chart) to deploy a simple TLS Secured hello world webservice inside the Kubernetes cluster. What are important points to consider?
    * Helm chart is [here](./k8s/java-deployment/templates/app.yaml).
    * Helm3 is used here to deploy , steps jotted here [here](./src/k8s/README.md)
    * Chart Values should be considered to switch between environments.
    * Once deployment with Helm it is easy to rollback to ugrade.
- Write a Github Action or Azure Devops Pipeline (whichever you are more comfortable with) to deploy and update the app. What update strategies would you recommend for the Use Case presented in the introduction?
    * We can follow the Google's [trunk based development](https://trunkbaseddevelopment.com/) stragies. 
    * Pipeline should generate a review app when a branch is checked out from SCM. 
    * When merged to main/trunk, it will deploy to QA and followed Live/prod. 

Solution: [wiki here](./src/k8s/README.md)

- Write a Github Action or Azure Devops Pipeline (whichever you are more comfortable with) to update the cluster itself. What important things should be watched out for before updating nodes? What are limitations?
* I would like to update the cluster in a different way that Update cluster.
    * Update the control plane of the cluster first.
    * Add new nodepool with updated version.
    * Cordon the old nodes to stop scheduling of pods.
    * Drain the exsiting connection to pods, and delete the deployments(replicas), this will schedule the deployments to new nodepool.
    * Repeat this until the old nodepool is empty. Be careful about deployments with 1 replicas, will face downtime.
    * Once no deployments are scheduled in old nodepool , we are good to delete the it. 
    * Cluster is updated, with no or very less downtime. :) 
* Cloud providers provide update directly and can be triggred from terraform, which might cause downtime, so I prefer to be careful and do it with the above steps.

- How would you document the steps to get someone new onboarded to your infrastructure and keep it in sync with every stage? (dev/test/prod)
* We can use tools like [shdoc](https://github.com/vargiuscuola/shdoc) or [terraform-docs](https://github.com/terraform-docs/terraform-docs)
* Usually we write the steps to be followed in README.md depecting installation process.
* I believe Code is the best documentation. 

Solution: [wiki here](./src/k8s/README1.md)

If you don't have access to an Azure subscription, try to get the deployment of the following running using Vagrant/Packer. It should be as automated as possible. The important part is that, anyone reading the documentation attached should be able to reproduce it. Don't over engineer things and keep it simple. 

Bonus:
- A developer complains to you that they need a local deployment of the whole backend (or a mock of it) on their local desktop. How would you help them solve their issue?
    * [minikube](https://minikube.sigs.k8s.io/docs/start/) is the best tool for local kubernetes deployment.
    * [Kind](https://github.com/kubernetes-sigs/kind) is also a similar tool.
    * I would ask him to install [Helm](https://helm.sh/) and one of the above (Minikube/Kind) and install in his work machine.
    * Next simply follow the helm deployment procedure, if any dependencies ofcourse I will highlight and guide through it, parally document it.
- Explain how you would implement a monitoring strategy for the system and how you would deploy & maintain it?
    * I would prefer to use [Prometheus](https://github.com/prometheus-community/helm-charts) & [Grafana](https://github.com/grafana/helm-charts) for monitoring the cluster workloads.
    * For logging I would prefer to use [Loki](https://grafana.com/docs/loki/latest/installation/helm/) with promtail deamonstes.

** Delivery

Please provide a zip file with machine readable formats (markdown, uml diagrams, ...) 

** Reviewing
What matters to us is to learn how you take design decisions and document your ideas and how you generally approach the problem given limited requirements. For us, it is more important to have an understandable project than a complex algorithm or 100% runnable code.
