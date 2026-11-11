# odoo-doodba

Odoo on Kubernetes from a [Doodba](https://github.com/Tecnativa/doodba)
project image. One release is one Odoo instance serving one database.

What you get, each part switchable:

| Part | Default | Notes |
|---|---|---|
| Odoo Deployment | on | 1 replica, `Recreate`, runs as `odoo` (1000), passes the *restricted* Pod Security Standard, probes on `/web/health` |
| `prepare` init container | on | installs `base` into an empty database, otherwise `click-odoo-update` (only addons whose code changed), then enforces `odoo.systemParameters` |
| PostgreSQL ([CloudNativePG](https://cloudnative-pg.io)) | on | Odoo reads the operator's `<name>-app` Secret; optional Barman Cloud backups (base + WAL) |
| Filestore PVC | on | annotated `k8up.io/backup: "true"/"false"` so the backup decision is always explicit; kept on uninstall |
| Volume backups ([k8up](https://k8up.io)) | off | restic Schedule (backup/prune/check) + nightly **restore test** (canary) pushed to a Pushgateway |
| Ingress | off | prefork mode routes `/websocket` (or `/longpolling`) to the gevent port |
| NetworkPolicies | off | ingress controller → Odoo, CNPG operator/monitoring → PostgreSQL, same-namespace traffic |

Requires the CRDs of whatever you enable: CloudNativePG (+ the
`barman-cloud` plugin for backups), k8up.

## Secrets

The chart creates no secrets and never takes one as a value:

- `odoo.adminPasswordSecret` (required): Odoo's master password.
- Database: CNPG's generated `<cnpg.name>-app`, or `externalDatabase.passwordSecret`.
- `cnpg.backup.s3Credentials.secretName`, `backup.s3.credentialsSecret`,
  `backup.passwordSecret`: object storage and restic.
- `imagePullSecrets`, `odoo.extraEnvFrom` for anything else (e.g. SMTP).

Create them with External Secrets (or add them through `extraObjects`).

## Minimal values

```yaml
image:
  repository: registry.example.com/my-odoo
  tag: "18.0-3f2a1bc"          # immutable tag or `digest`
odoo:
  database: mycompany
  adminPasswordSecret: { name: odoo-admin }
ingress:
  enabled: true
  className: traefik
  host: erp.example.com
```

## Configuration

Doodba builds `odoo.conf` at start from its templates and environment
variables; the chart sets `PG*`, `DB_FILTER` (`^<database>$`), `LIST_DB`,
`PROXY_MODE`, `WITHOUT_DEMO`, `UNACCENT`, `ADMIN_PASSWORD` and adds
`conf.d/90-helm.conf` with `workers`, `max_cron_threads`, `odoo.config` and
`odoo.extraSections`.

- **Threaded vs prefork**: `odoo.workers: 0` (default) runs everything in one
  process, enough for a handful of users. With `workers > 0` the gevent
  process listens on `service.geventPort` and the Ingress routes
  `ingress.geventPath` there.
- **`report.url`**: wkhtmltopdf downloads the report CSS from Odoo. If the
  public URL is behind an authentication gate, PDFs come out unstyled; the
  default `odoo.systemParameters` points it at `http://localhost:8069`.
- **Odoo 15 and older** have no `/web/health`: set `probes.type: tcp` and
  `ingress.geventPath: /longpolling`.
- **SELinux hosts** (e.g. openSUSE MicroOS): set a fixed
  `podSecurityContext.seLinuxOptions.level` per release; the backup and canary
  pods reuse it, otherwise they cannot read the volume (and restic reports
  the files as errors while the backup still "succeeds").

## Deploying a new image

1. Build and push an immutable tag (`<odoo version>-<commit>`).
2. Change `image.tag` in the release values (git, for Flux).
3. The pod is recreated; `prepare` updates the changed addons before Odoo
   serves. Check: `kubectl logs deploy/<release>-odoo -c prepare`.

Rolling back the image does not roll back a module update's database
changes: restore the database (CNPG point-in-time) if a migration must be
undone.

## Restore test (canary)

With `backup.canary.enabled`, a CronJob writes a timestamp to
`.backup-canary` at the volume root before the backup, and another restores
only that file from the latest snapshot afterwards, into its own `/tmp`. It
pushes `backup_canary_restore_success` and `backup_canary_age_seconds`
(`job="backup_canary"`, `instance="<namespace>"`) to `backup.promURL`; alert
on failure, on age, and on missing pushes.

## Upgrading from 3.x

4.0 is a rewrite and shares no values with 3.x. The Bitnami PostgreSQL/Redis
subcharts, Cloud SQL proxy, pgBouncer and generated secrets are gone. Move
an instance by deploying 4.x next to it (new release name/namespace),
restoring a database dump and copying the filestore, then switching DNS.
