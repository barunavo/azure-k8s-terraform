- Write a Yaml (or Helm Chart) to deploy a simple TLS Secured hello world webservice inside the Kubernetes cluster. What are important points to consider?
- Write a Github Action or Azure Devops Pipeline (whichever you are more comfortable with) to deploy and update the app. What update strategies would you recommend for the Use Case presented in the introduction?

- Step 1.
# TLS secret 
```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out aks-ingress-tls.crt -keyout aks-ingress-tls.key -subj "/CN=demo.barunavo.com/O=aks-ingress-tls"

$ kubectl create namespace app

$ kubectl create secret tls aks-ingress-tls --namespace app --key aks-ingress-tls.key --cert aks-ingress-tls.crt

```
- Step 2. 
# Nginx ingress controller 

```
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm upgrade --install nginx-ingress -f values-nginx-ingress-controller.yaml ingress-nginx/ingress-nginx
```

- Step 3.
# Helm installation of app

```
$ helm upgrade --install --namespace app --values java-deployment/values-dev.yaml app java-deployment
```
# what we deployed

```
$ kubectl get ingress -n app                                                                            

NAME   CLASS    HOSTS               ADDRESS        PORTS     AGE
app    <none>   demo.barunavo.com   20.81.29.174   80, 443   20m

$ kubectl get po -n app

NAME                  READY   STATUS    RESTARTS   AGE
app-64f685475-bdv8c   1/1     Running   0          33m

```
# tls verification

```
$ curl -v -k --resolve demo.barunavo.com:443:20.81.29.174 https://demo.barunavo.com

* Added demo.barunavo.com:443:20.81.29.174 to DNS cache
* Hostname demo.barunavo.com was found in DNS cache
*   Trying 20.81.29.174...
* TCP_NODELAY set
* Connected to demo.barunavo.com (20.81.29.174) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/cert.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  start date: Sep  4 06:53:29 2021 GMT
*  expire date: Sep  4 06:53:29 2022 GMT
*  issuer: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7ff46c80c400)
> GET / HTTP/2
> Host: demo.barunavo.com
> User-Agent: curl/7.64.1
> Accept: */*
>
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 200
< date: Sat, 04 Sep 2021 07:12:05 GMT
< content-type: text/plain;charset=UTF-8
< content-length: 28
< strict-transport-security: max-age=15724800; includeSubDomains
<
* Connection #0 to host demo.barunavo.com left intact
Greeting from Barunavo Pal! * Closing connection 0
```





