# biocad_test

## Files

### deployment.yaml
С двумя репликами

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test
  labels:
    app: test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: test
        image: gulshad/my_repo:latest
        ports:
        - containerPort: 32777 
```

### service.yaml
Тип NodePort

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: Test
  ports:
    - protocol: TCP
      port: 32777
      targetPort: 32777
  type: NodePort
```

## Commands

Запустили minikube:
```
minikube start
# wait until start
```
Затем через kubectl (alias) запускаем деплоймент и сервис:

```
ztvgzh@Ubuntu:~/Documents/app$ kubectl apply -f deployment.yaml 
deployment.apps/test created
ztvgzh@Ubuntu:~/Documents/app$ kubectl apply -f service.yaml 
service/my-service created
```
Проверяем:

```
ztvgzh@Ubuntu:~/Documents/app$ kubectl get all
NAME                        READY   STATUS    RESTARTS   AGE
pod/test-6bbcbccb7f-j856w   1/1     Running   0          14s
pod/test-6bbcbccb7f-ln474   1/1     Running   0          15s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
service/kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP           96m
service/my-service   NodePort    10.110.113.134   <none>        32777:30492/TCP   4s

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/test   2/2     2            2           15s

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/test-6bbcbccb7f   2         2         2       15s
```
Получаем с помощью команды describe больше информации о сервисе:

```
ztvgzh@Ubuntu:~/Documents/app$ kubectl describe service/my-service
Name:                     my-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=Test
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.110.113.134
IPs:                      10.110.113.134
Port:                     <unset>  32777/TCP
TargetPort:               32777/TCP
NodePort:                 <unset>  30492/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

Делаем проброс портов через port-forward, у меня они пробразываются по отдельности:
```
ztvgzh@Ubuntu:~/Documents/app$ kubectl port-forward pod/test-6bbcbccb7f-ln474 32777:32777
Forwarding from 127.0.0.1:32777 -> 32777
Forwarding from [::1]:32777 -> 32777
Handling connection for 32777
Handling connection for 32777
Handling connection for 32777
```

## Result

Результат можно увидеть на `localhost:32777` в браузере:
<div align = "center"><img src="https://github.com/ztvgzh/biocad_test/blob/master/result.jpg"></div>

## Delete everything

```
minikube delete
# wait until finish
```

```
minikube stop
# wait until finish
```

## Схемы
<div align = "center"><img src="https://github.com/ztvgzh/biocad_test/blob/master/depl.jpg"></div>
<div align = "center"><img src="https://github.com/ztvgzh/biocad_test/blob/master/serv.jpg"></div>
