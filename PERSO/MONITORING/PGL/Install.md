# Install - Stack monitoring homelab

Prometheus + Node Exporter + AlertManager + Grafana + Loki + Promtail + Consul, en Docker Compose.

## Arborescence

```
$HOME
└── monitoring/
    ├── compose.yaml
    ├── grafana
    │   └── datasource.yml
    ├── prometheus
    │   └── prometheus.yml
    ├── alertmanager
    │   └── alertmanager.yml
    ├── loki
    │   └── loki-config.yml
    ├── promtail
    │   └── promtail-config.yml
    ├── consul
    └── README.md
```

Création :
```bash
mkdir -p ~/monitoring/{grafana,prometheus,alertmanager,loki,promtail,consul}
```

## 1. compose.yaml

`~/monitoring/compose.yaml` :

```yaml
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    ports:
      - 9090:9090
    restart: unless-stopped
    volumes:
      - ./prometheus:/etc/prometheus
      - prom_data:/prometheus

  node_exporter:
    image: quay.io/prometheus/node-exporter:latest
    container_name: node_exporter
    command:
      - '--path.rootfs=/host'
    network_mode: host
    pid: host
    restart: unless-stopped
    volumes:
      - '/:/host:ro,rslave'

  alertmanager:
    image: prom/alertmanager:v0.27.0
    container_name: alertmanager
    restart: unless-stopped
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    ports:
      - 9093:9093

  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - 3000:3000
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=changeme
    volumes:
      - ./grafana:/etc/grafana/provisioning/datasources
      - grafana_data:/var/lib/grafana

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - 3100:3100
    restart: unless-stopped
    volumes:
      - ./loki/loki-config.yml:/etc/loki/local-config.yaml
      - loki_data:/loki
    command: -config.file=/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    restart: unless-stopped
    volumes:
      - ./promtail/promtail-config.yml:/etc/promtail/config.yml
      - /var/log:/var/log:ro
    command: -config.file=/etc/promtail/config.yml

  consul:
    image: hashicorp/consul:latest
    container_name: consul
    restart: unless-stopped
    volumes:
      - consul_data:/consul/data
    ports:
      - 8500:8500
      - 8600:8600/udp
      - 8600:8600/tcp
      - 8301:8301
      - 8301:8301/udp
    command: agent -server -bootstrap-expect=1 -ui -client=0.0.0.0 -data-dir=/consul/data
    environment:
      - CONSUL_LOCAL_CONFIG={"encrypt":"REMPLACER_PAR_TA_CLE_CONSUL_KEYGEN"}

volumes:
  prom_data:
  grafana_data:
  loki_data:
  consul_data:
```

## 2. prometheus/prometheus.yml

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
```

## 3. grafana/datasource.yml

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
```

## 4. alertmanager/alertmanager.yml

```yaml
route:
  receiver: 'mail-default'
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h

receivers:
  - name: 'mail-default'
    email_configs:
      - to: 'destinataire@ton-domaine.fr'
        from: 'alertmanager@ton-domaine.fr'
        smarthost: 'smtp.ton-domaine.fr:587'
        auth_username: 'alertmanager@ton-domaine.fr'
        auth_password: 'CHANGER_MOT_DE_PASSE'
        require_tls: true
```

## 5. loki/loki-config.yml

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

limits_config:
  retention_period: 336h
```

## 6. promtail/promtail-config.yml

```yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
```

## Avant de lancer

- [ ] Générer la clé gossip Consul : `docker run --rm hashicorp/consul consul keygen`, remplacer `REMPLACER_PAR_TA_CLE_CONSUL_KEYGEN` dans `compose.yaml`
- [ ] Changer `GF_SECURITY_ADMIN_PASSWORD` dans `compose.yaml`
- [ ] Adapter `alertmanager/alertmanager.yml` avec les vraies infos SMTP (host, port, identifiants)
- [ ] Vérifier `retention_period` dans `loki-config.yml` selon l'espace disque dispo

## Lancer la stack

```bash
cd ~/monitoring
docker compose up -d
```

## Accès

- Prometheus : http://IP_VM:9090
- Grafana : http://IP_VM:3000
- AlertManager : http://IP_VM:9093
- Loki (API) : http://IP_VM:3100
- Consul (UI) : http://IP_VM:8500

## Étapes suivantes

- Remplacer la liste statique de targets Prometheus par la découverte via Consul (`consul_sd_config`)
- Activer ACL + TLS sur Consul une fois la base validée
- Enregistrer les services (Uptime Kuma, etc.) dans Consul
