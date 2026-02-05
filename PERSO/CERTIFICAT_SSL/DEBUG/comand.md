1. Vérifier un certificat depuis un fichier
bash

    openssl x509 -in certificat.crt -text -noout
   
Affiche toutes les informations du certificat (subject, issuer, dates, extensions, etc.) sans l’afficher en Base64.

3. Vérifier la correspondance clé privée / certificat

    openssl x509 -noout -modulus -in certificat.crt | openssl md5
   
    openssl rsa -noout -modulus -in private.key | openssl md5
   
Compare les valeurs MD5 pour s’assurer que la clé privée correspond bien au certificat.


5. Vérifier un certificat depuis un serveur distant

    openssl s_client -connect example.com:443 -showcerts
   
Se connecte à un serveur HTTPS et affiche le ou les certificats envoyés par le serveur.

7. Vérifier la date de validité d’un certificat

    openssl x509 -in certificat.crt -noout -dates
   
Affiche la date de début et la date d’expiration du certificat.

8. Vérifier la chaîne de certificats

    openssl verify -CAfile ca_bundle.crt certificat.crt
   
Vérifie si le certificat est correctement signé par la CA et si la chaîne est valide.

10. Extraire la clé publique d’un certificat

    openssl x509 -in certificat.crt -pubkey -noout
    
Permet d’obtenir la clé publique contenue dans le certificat.

12. Vérifier un CSR (Certificate Signing Request)
  
    openssl req -in demande.csr -noout -text
    
Affiche les informations contenues dans une demande de signature de certificat.

14. Convertir un certificat entre formats
 
    openssl x509 -in certificat.pem -out certificat.der -outform DER

     openssl x509 -in certificat.der -out certificat.pem -outform PEM

Convertit un certificat PEM en DER ou l’inverse.

16. Tester la connexion SSL avec debug +++
 
    openssl s_client -connect example.com:443 -tls1_2 -servername example.com

Permet de tester la connexion SSL/TLS vers un serveur précis et de forcer une version de TLS.

17. Afficher le fingerprint d’un certificat

    openssl x509 -in certificat.crt -noout -fingerprint

Affiche l’empreinte (hash) du certificat pour vérification.




