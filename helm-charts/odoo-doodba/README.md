Odoo Doodba

## Parameters

### 

| Name                                 | Description                                                                                                                    | Value              |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| `replicaCount`                       | Number of Odoo replicas to deploy                                                                                              | `1`                |
| `rollDeploy`                         | Activates a new deployment with each helm upgrade regardless of diff in chances                                                | `false`            |
| `annotations`                        | Annotations for Odoo pods                                                                                                      | `{}`               |
| `updateStrategy.type`                | Odoo deployment strategy type                                                                                                  | `RollingUpdate`    |
| `updateStrategy.rollingUpdate`       | Odoo deployment rolling update configuration parameters                                                                        | `{}`               |
| `image.repository`                   | Odoo image repository                                                                                                          | `tecnativa/doodba` |
| `image.tag`                          | Odoo image tag (immutable tags are recommended)                                                                                | `15.0`             |
| `image.pullPolicy`                   | Odoo image pull policy                                                                                                         | `IfNotPresent`     |
| `imagePullSecrets`                   | Global Docker registry secret names as an array                                                                                | `[]`               |
| `nameOverride`                       | String to partially override common.names.fullname                                                                             | `""`               |
| `fullnameOverride`                   | String to fully override common.names.fullname                                                                                 | `""`               |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                                           | `false`            |
| `serviceAccount.name`                | The name of the ServiceAccount to create                                                                                       | `""`               |
| `podSecurityContext.enabled`         | Enabled Odoo pods' Security Context                                                                                            | `false`            |
| `podSecurityContext.fsGroup`         | Set Odoo pod's Security Context fsGroup                                                                                        | `1001`             |
| `containerSecurityContext.enabled`   | Enabled Odoo containers' Security Context                                                                                      | `false`            |
| `containerSecurityContext.runAsUser` | Set Odoo container's Security Context runAsUser                                                                                | `1001`             |
| `odooPassword`                       | Odoo user password                                                                                                             | `""`               |
| `config`                             | values in odoo.conf format as multiline string will be merged with the default odoo.conf file and override any existing values | `""`               |
| `pgBouncer.enabled`                  | Enable a subchart that launches the pgBouncer connection pooler as a middleware between odoo and postgresql                    | `false`            |


### Odoo postgresql cluster database

| Name                            | Description                            | Value      |
| ------------------------------- | -------------------------------------- | ---------- |
| `postgresql.enabled`            | Deploy PostgreSQL container(s)         | `true`     |
| `postgresql.image.repository`   | Docker repository for postgresql image | `postgres` |
| `postgresql.image.tag`          | Docker image tag for postgresql image  | `latest`   |
| `postgresql.postgresqlUsername` | PostgreSQL non-root username           | `odoo`     |
| `postgresql.postgresqlPassword` | PostgreSQL password                    | `""`       |
| `postgresql.postgresHost`       | External Database server host          | `""`       |
| `postgresql.port`               | External Database server port          | `5432`     |
| `postgresql.externalDatabase`   | standard or gcloud                     | `""`       |


### Google cloud SQL

| Name                                  | Description                                                                        | Value |
| ------------------------------------- | ---------------------------------------------------------------------------------- | ----- |
| `postgresql.gcInstanceConnectionName` | Psql instance name on google cloud                                                 | `""`  |
| `postgresql.gcCredentialsFile`        | Filename of svc account credentials stored in cloudsql-instance-credentials secret | `""`  |


### Redis session storage

| Name                                     | Description                                                                                                                            | Value                    |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `redis.enabled`                          | Enable redis subchart for deployment                                                                                                   | `false`                  |
| `redis.password`                         | Password to redis instance                                                                                                             | `redis-password`         |
| `redis.cluster.enabled`                  | Enable deployment of a multi-tier cluster                                                                                              | `false`                  |
| `service.type`                           | Odoo service type                                                                                                                      | `ClusterIP`              |
| `service.port`                           | Odoo service HTTP port                                                                                                                 | `80`                     |
| `service.longPollingPort`                | Odoo service HTTP port                                                                                                                 | `8072`                   |
| `service.annotations`                    | Additional custom annotations for Odoo service                                                                                         | `{}`                     |
| `service.loadBalancerIP`                 | Odoo service Load Balancer IP                                                                                                          | `""`                     |
| `ingress.enabled`                        | Enable ingress record generation for Odoo                                                                                              | `false`                  |
| `ingress.pathType`                       | Ingress path type                                                                                                                      | `ImplementationSpecific` |
| `ingress.recommendedNginxSettings`       | Set of ingress annotations that increase nginx timeout and provides g-zip                                                              | `true`                   |
| `ingress.wwwRedirect`                    | Enable redirect from www domain to non-www domain using an ingress annotation                                                          | `false`                  |
| `ingress.annotations`                    | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.       | `{}`                     |
| `ingress.hosts`                          | An array with hostname(s) to be covered with the ingress record                                                                        | `[]`                     |
| `ingress.tls`                            | An array of hostname(s) provided in ingress.hosts to be covered by TLS                                                                 | `[]`                     |
| `ingress.cache.enabled`                  | Enable cache by creating a separate ingress with rules and headers just for cacheable paths (/static/*)                                | `false`                  |
| `ingress.cache.recommendedNginxSettings` | Add recommended (default) nginx annotations for nginx cache to work                                                                    | `true`                   |
| `ingress.cache.annotations`              | Additional annotations for the Cache Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.cache.hosts`                    |                                                                                                                                        | `[]`                     |
| `ingress.cache.paths`                    |                                                                                                                                        | `[]`                     |
| `ingress.cache.tls`                      | Same tls configuration as in the main ingress if cache is applied over SSL connection                                                  | `[]`                     |
| `persistence.enabled`                    | Enable persistence using Persistent Volume Claims                                                                                      | `true`                   |
| `persistence.initVolume`                 | Activate init-container which casts chown on the odoo-volume (filestore)                                                               | `true`                   |
| `persistence.storageClass`               | Persistent Volume storage class                                                                                                        | `""`                     |
| `persistence.accessMode`                 | Persistent Volume access modes                                                                                                         | `[]`                     |
| `persistence.size`                       | Persistent Volume size                                                                                                                 | `8Gi`                    |
| `persistence.volumeName`                 | The name of the PVC                                                                                                                    | `odoo`                   |
| `persistence.subPath`                    | refer to a path within the mounted volume (useful for NFS shared storage and multiple environments/deployments)                        | `""`                     |
| `persistence.annotations`                | Additional annotations for the PVC                                                                                                     | `{}`                     |
| `persistence.existingClaim`              | refers to the full name of an existing PVC so as to not create a new one but reuse the existing resource                               | `""`                     |
| `persistence.extraVolumeMounts`          | additional server volumeMounts (usefull in NFS scenarios to access live filestore for staging replication)                             | `[]`                     |
| `resources.limits`                       | The resources limits for the Odoo container                                                                                            | `{}`                     |
| `resources.requests`                     | The requested resources for the Odoo container                                                                                         | `{}`                     |
| `livenessProbe.enabled`                  | Enable livenessProbe                                                                                                                   | `true`                   |
| `livenessProbe.initialDelaySeconds`      | Initial delay seconds for livenessProbe                                                                                                | `60`                     |
| `livenessProbe.periodSeconds`            | Period seconds for livenessProbe                                                                                                       | `30`                     |
| `livenessProbe.timeoutSeconds`           | Timeout seconds for livenessProbe                                                                                                      | `5`                      |
| `livenessProbe.failureThreshold`         | Failure threshold for livenessProbe                                                                                                    | `10`                     |
| `livenessProbe.successThreshold`         | Success threshold for livenessProbe                                                                                                    | `1`                      |
| `readinessProbe.enabled`                 | Enable readinessProbe                                                                                                                  | `true`                   |
| `readinessProbe.initialDelaySeconds`     | Initial delay seconds for readinessProbe                                                                                               | `30`                     |
| `readinessProbe.periodSeconds`           | Period seconds for readinessProbe                                                                                                      | `10`                     |
| `readinessProbe.timeoutSeconds`          | Timeout seconds for readinessProbe                                                                                                     | `5`                      |
| `readinessProbe.failureThreshold`        | Failure threshold for readinessProbe                                                                                                   | `10`                     |
| `readinessProbe.successThreshold`        | Success threshold for readinessProbe                                                                                                   | `1`                      |
| `nodeSelector`                           | Node labels for pod assignment                                                                                                         | `{}`                     |
| `tolerations`                            | Tolerations for pod assignment                                                                                                         | `[]`                     |
| `affinity`                               | Affinity for pod assignment                                                                                                            | `{}`                     |
