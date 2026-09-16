## Rapport monitoring automatisés

- Ici réalisation d'un pipe automatisé pour vérifier si les jobs `Bareos` programmés le dimanche (déclenchement à 12:20) sont terminés. Dans les deux cas, succès ou erreur, un message part sur `Win 11` et sur le téléphone via Telegram, avec proposition d'extinction.

### `=== Fichier Flux ===`

- `1` [Installation de n8n](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-1-%20Install-n8n.md)
- `2` [Mise en place VPN sur Pfsense](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-2-%20VPN/-1-%20Pfsense-WireGuard.md)
- `3` [Mise en place VPN sur VPS](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-2-%20VPN/-2-%20VPN-Client.md)
- `4` [Edition Script](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)
- `5` [Pipeline](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-2-Pipeline.md)

---

### `=== Shémas Flux ===`
````
                         INTERNET
                            |
                      [Telegram API]
                            |  HTTPS (hors tunnel)
                            v
                    +---------------+
                    |  VPS (n8n)    |
                    | 176.31.163.227|
                    +-------+-------+
                            |
                            | tunnel WireGuard
                            | (SSH direct)
                    +-------+-------+
                    |               |
                    v               v
            +-------------+  +-------------+
            |    .240     |  |    .235     |
            |   Bareos    |  |   Win 11    |
            +-------------+  +-------------+
.240 <- SSH : lecture statut (bconsole) + shutdown -h now
.235 <- SSH : popup .vbs (fire-and-forget) + shutdown /s /t 0 ou /a
````
