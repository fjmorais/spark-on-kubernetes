Step-by-Step Guide to Fix Git Sync Issues for Spark on Kubernetes
Here’s a full end-to-end guide starting from generating your SSH keys, encoding them, creating a Kubernetes Secret, and applying all the necessary changes in your YAML files to fix the error.


Step 1: Generate SSH Keys for GitHub
If you haven't done it yet, follow these steps to generate SSH keys for GitHub:

1.Generate SSH Key Pair (Skip this if you already have a key):

On your local machine, run:

```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

This will create two files:

~/.ssh/id_ed25519 (your private key)

~/.ssh/id_ed25519.pub (your public key)

2.Add Your Public Key to GitHub:

Go to GitHub > Settings > SSH and GPG keys > New SSH key.

Copy the content of id_ed25519.pub and paste it in GitHub.

```
cat ~/.ssh/id_ed25519.pub
```
Paste this into the GitHub SSH keys section.


Step 2: Prepare SSH Key and Known Hosts
1 -SSH Private Key (id_ed25519):

Your private key (stored in ~/.ssh/id_ed25519) will be used to authenticate with GitHub.

2 - Known Hosts:

This file contains the GitHub SSH fingerprints that ensure you’re connecting to the legitimate GitHub servers.

Run this command to generate the known_hosts file:

```
ssh-keyscan github.com > ~/.ssh/known_hosts
```

Step 3: Base64 Encode SSH Key and Known Hosts

Next, you need to base64-encode both your SSH private key and known_hosts file, as Kubernetes Secrets require base64-encoded values.

1-Encode SSH Private Key:

```
base64 -w 0 ~/.ssh/id_ed25519
```

This will output a base64 string like this:

```
c3NoLXRpc3Q... (your actual base64-encoded private key)
```

2 - Encode Known Hosts:

```
base64 -w 0 ~/.ssh/known_hosts

```

This will output a base64 string like this:

```
aG9zdC1uYW1l... (your actual base64-encoded known_hosts file)
```


Step 4: Create Kubernetes Secret
Now that you have both base64-encoded values, create a Kubernetes Secret that holds these encoded files.

1 - Create Secret YAML File (git-creds-secret.yaml):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-creds
type: Opaque
data:
  ssh: <base64-encoded-ssh-private-key>   # Replace with the SSH private key base64 string
  known_hosts: <base64-encoded-known-hosts>  # Replace with the known_hosts base64 string
```

Replace the placeholders (<base64-encoded-ssh-private-key> and <base64-encoded-known-hosts>) with your actual base64-encoded SSH private key and known_hosts data.

For example, if the base64-encoded values are:

```yaml
ssh: c3NoLXRpc3Q...
known_hosts: aG9zdC1uYW1l...
```

Your secret YAML will look like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-creds
type: Opaque
data:
  ssh: c3NoLXRpc3Q...
  known_hosts: aG9zdC1uYW1l...
```

2. Apply the Secret to Kubernetes:

Now apply the secret to your Kubernetes cluster:

```
kubectl apply -f git-creds-secret.yaml
```


Step 5: Update Your SparkApplication YAML
Now, update your SparkApplication YAML file to use the newly created Kubernetes secret and ensure that the git-sync init container and the Spark driver are correctly referencing it.

1 - Modify the SparkApplication YAML to mount the secret and configure git-sync:

```yaml
apiVersion: sparkoperator.k8s.io/v1beta2
kind: SparkApplication
metadata:
  name: spark-lab10
  namespace: processing
spec:
  type: Python
  pythonVersion: "3"
  mode: cluster
  image: fabianomorais/spok:1.0.0
  imagePullPolicy: Always
  mainApplicationFile: "local:///repo/spark-on-kubernetes.git/labs/lab-10/scripts/spark-app4-2.py"
  sparkConf:
    spark.hadoop.fs.s3a.endpoint: "http://datalake-hl.deepstore:9000"
    spark.hadoop.fs.s3a.path.style.access: "true"
    spark.hadoop.fs.s3a.impl: "org.apache.hadoop.fs.s3a.S3AFileSystem"
    spark.metrics.conf: "/etc/metrics/conf/metrics.properties"
  arguments:
    - "silver"
    - "owshq-shadow-traffic-uber-eats/kafka/orders"
    - "owshq-shadow-traffic-uber-eats/mysql/products"
    - "owshq-shadow-traffic-uber-eats/mongodb/items"
    - "s3a://owshq-shadow-traffic-uber-eats/parquet"
  volumes:
    - name: aux-dir
      emptyDir: {}
    - name: git-creds-volume
      secret:
        secretName: git-creds  # Referencing the secret here
  sparkVersion: 3.5.3
  timeToLiveSeconds: 30
  restartPolicy:
    type: OnFailure
    onFailureRetries: 2
    onFailureRetryInterval: 10
    onSubmissionFailureRetries: 5
    onSubmissionFailureRetryInterval: 10
  driver:
    cores: 1
    memory: 1024m
    serviceAccount: spark-operator-spark
    envSecretKeyRefs:
      AWS_ACCESS_KEY_ID:
        name: minio-spark-secret
        key: AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY:
        name: minio-spark-secret
        key: AWS_SECRET_ACCESS_KEY
    volumeMounts:
      - name: aux-dir
        mountPath: /repo
      - name: git-creds-volume
        mountPath: /etc/git-secret-init  # Mount path for SSH credentials
    initContainers:
      - name: git-sync
        image: k8s.gcr.io/git-sync/git-sync:v4.2.4
        args:
          - "--repo=git@github.com:fjmorais/spark-on-kubernetes.git"
          - "--root=/repo"
          - "--ref=main"
          - "--depth=2"
          - "--one-time"
          - "--ssh-key-file=/etc/git-secret-init/ssh"
          - "--ssh-known-hosts-file=/etc/git-secret-init/known_hosts"
        volumeMounts:
          - name: aux-dir
            mountPath: /repo
          - name: git-creds-volume
            mountPath: /etc/git-secret-init  # Correct volume mount path for SSH credentials
  executor:
    instances: 2
    cores: 1
    memory: 1024m
    envSecretKeyRefs:
      AWS_ACCESS_KEY_ID:
        name: minio-spark-secret
        key: AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY:
        name: minio-spark-secret
        key: AWS_SECRET_ACCESS_KEY
  monitoring:
    exposeDriverMetrics: true
    exposeExecutorMetrics: true
    prometheus:
      jmxExporterJar: /prometheus/jmx_prometheus_javaagent-0.11.0.jar
      port: 8090
```

Step 6: Apply Your SparkApplication
After updating your SparkApplication YAML, apply the changes to your Kubernetes cluster:

```
kubectl apply -f spark-application.yaml
```

This will launch your Spark job with the git-sync init container, which will clone the repository and use the SSH key stored in the Kubernetes Secret to authenticate with GitHub.

Step 7: Debugging and Logs
If the application doesn’t work as expected, check the logs of the git-sync init container and the Spark driver:

1 - Check git-sync logs:

```
kubectl logs <pod-name> -c git-sync
```

2 - Check the Spark driver logs:

```
kubectl logs <pod-name> -c driver
```

Look for errors related to SSH authentication or GitHub connection issues, and ensure that the SSH key and known_hosts file are properly mounted inside the container.

Conclusion
That’s it! You’ve now successfully:

Generated the SSH key pair and added it to GitHub.

Base64-encoded the SSH key and known hosts file.