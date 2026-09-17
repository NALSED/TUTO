## `-1-` `Webhook`

`- 1.1` En haut à droite `Create wrokflow` => `+` => `Webhook`

`- 1.2` Configuration node Webhook :

- HTTP Method    : POST

- Path           : !!! Doit être le même "URL_N8N=" que dans le [recup-status-bareos.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md#-1--script-de-r%C3%A9cup%C3%A9ration-du-statut-1921680240) !!!

- Authentication : Header Auth

- Respond        : Immediately

- Credential for `Header Auth` :

   - Name  : Bareos-Token

   - Value :!!! Doit être le même "TOKEN_N8N=" que dans le [recup-status-bareos.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md#-1--script-de-r%C3%A9cup%C3%A9ration-du-statut-1921680240) !!!


`[NOTE]`

- Derrière Caddy, si l'URL affichée dans le node n'est pas la bonne, ajouter `WEBHOOK_URL=https://n8n.nalsed.fr/` au `compose.yml` — voir [-1- Install-n8n.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-1-%20Install-n8n.md)

### ===> [SCREEN WEBHOOK](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-6-SCREEN.md#webhook) <===

- **FIN DE CONFIGURATION**

<img width="363" height="228" alt="image" src="https://github.com/user-attachments/assets/9858f638-2a3e-4722-a9f8-5a6d91ce1797" />
