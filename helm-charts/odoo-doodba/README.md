Odoo Doodba

## Parameters

### Common parameters

| Name                | Description                                        | Value                        |
| ------------------- | -------------------------------------------------- | ---------------------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`                         |
| `nameOverride`      | String to partially override common.names.fullname | `""`                         |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`                         |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`                         |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`                         |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`                         |
| `image.registry`    | Odoo image registry                                | `docker.io`                  |
| `image.repository`  | Odoo image repository                              | `bitnami/odoo`               |
| `image.tag`         | Odoo image tag (immutable tags are recommended)    | `15.0.20220110-debian-10-r1` |
| `image.pullPolicy`  | Odoo image pull policy                             | `IfNotPresent`               |
| `image.pullSecrets` | Odoo image pull secrets                            | `[]`                         |