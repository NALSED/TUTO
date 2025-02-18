<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BillU - Services</title>
    <style>

        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #1e1e1e;
            color: white;
            text-align: center;
        }

        /* Entête */
        .header {
            background: #222;
            padding: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
        }

        .header h1 {
            margin: 0;
            color: white;
            font-size: 36px;
            letter-spacing: 2px;
        }

        nav ul {
            list-style: none;
            margin-top: 20px;
        }

        nav ul li {
            display: inline;
            margin: 0 30px;
        }

        nav ul li a {
            color: #fff;
            text-decoration: none;
            font-size: 18px;
            letter-spacing: 1px;
        }

        nav ul li a:hover {
            color: #00aaff;
        }

        /* Conteneur des services */
        .icon-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin: 40px auto;
            max-width: 1200px;
            padding-bottom: 80px; /* Augmenter l'espace entre les services et le bas */
        }

        .icon-wrapper {
            background: #2a2a2a;
            border-radius: 10px;
            padding: 20px;
            margin: 15px;
            text-align: center;
            position: relative;
            width: 150px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
            cursor: pointer;
        }

        .icon-wrapper:hover {
            transform: scale(1.05);
        }

        .icon {
            width: 60px;
            height: 60px;
        }

        .status-dot {
            position: absolute;
            bottom: 10px;
            left: 10px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: gray;
        }

        .status-dot.up {
            background-color: green;
        }

        .status-dot.down {
            background-color: red;
        }

        .service-name {
            font-size: 1rem;
            margin: 10px 0;
            font-weight: bold;
        }

        .status-text {
            font-size: 0.9rem;
            color: #fff;
        }

        .status-text.up {
            color: #28a745;
        }

        .status-text.down {
            color: #dc3545;
        }

        /* Pied de page */
        .footer {
            background: #222;
            padding: 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            text-align: center;
            color: #ccc;
            margin-top: 40px; /* Augmenter l'espace entre le pied de page et les services */
        }

        /* Animation pour l'entête et les services */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        .header {
            animation: fadeIn 1s ease-out forwards;
        }

        .icon-wrapper {
            animation: fadeIn 1.5s ease-out forwards;
        }
    </style>
</head>

<body>

    <!-- Entête -->
    <header class="header">
        <div>
            <h1>BILLU</h1>
            <nav>
                <ul>
                    <li><a href="index.html">Accueil</a></li>
                    <li><a href="infra.html">Infra</a></li>
                    <li><a href="apropos.html">À propos</a></li>
                    <li><a href="contact.html">Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Contenu des services -->
    <div class="icon-container" id="services-container">
        <!-- Les services seront générés dynamiquement ici -->
    </div>

    <!-- Pied de page -->
    <footer class="footer">
        <p>&copy; 2025 BillU | Tous droits réservés</p>
    </footer>

    <script>
        const services = [
            { name: 'pfSense', url: 'http://192.168.10.254/', img: 'https://wpcomputersolutions.com/wp-content/uploads/2018/07/pfsense-logo-e1534531558807.png' },
            { name: 'GLPI', url: 'http://glpi.billu.com/glpi/', img: 'https://glpi-project.org/wp-content/uploads/2021/06/logo-glpi-bleu-1.png' },
            { name: 'Passbolt', url: 'http://passbolt.billu.com/', img: 'https://static.cdnlogo.com/logos/p/97/passbolt.svg' },
            { name: 'Graylog', url: 'http://graylog.billu.com:9000/', img: 'https://static.cdnlogo.com/logos/g/32/graylog.svg' },
            { name: 'FreePBX', url: 'http://freepbx.billu.com/', img: 'https://cp.beget.com/shared/xisQQW8k-g5QWd77x9XCtcysQ5hIWg3I/logo_freepbx2x.png' },
            { name: 'iRedMail', url: 'https://mail.billu.com/mail/', img: 'https://www.iredmail.org/images/logo.png' },
            { name: 'Zabbix', url: 'http://zabbix.billu.com:8080/', img: 'https://ssd-disclosure.com/wp-content/uploads/2022/11/1_vloEha9mTCLM_SEnXdIUIw-300x300.png' },
            { name: 'Guacamole Bastion', url: 'http://bastion.billu.com:8080/guacamole/#/', img: 'https://d7umqicpi7263.cloudfront.net/img/product/030b6dbb-cd7b-486d-af34-99d4924864a1.com/6fb7788920aacfd15ab8e000e0f750a3' },
            { name: 'GitHub', url: 'https://github.com/WildCodeSchool/TSSR-2409-VERT-P3-G1-build-your-infra', img: 'https://static.cdnlogo.com/logos/g/69/github-icon.svg' },
            { name: 'Mailo', url: 'https://www.mailo.com/', img: './pictures/Mailo_logo.png' }
        ];

        function createServiceCard(service) {
            return `
                <div class="icon-wrapper" data-service="${service.url}">
                    <a href="${service.url}" target="_blank">
                        <img class="icon" src="${service.img}" alt="${service.name}">
                    </a>
                    <div class="service-name">${service.name}</div>
                    <div class="status-dot" id="status-${service.name}"></div>
                    <div id="status-text-${service.name}" class="status-text">Vérification en cours...</div>
                </div>
            `;
        }

        async function checkServiceStatus(url) {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 5000); // timeout 5 sec

            try {
                const response = await fetch(url, {
                    method: 'HEAD',
                    mode: 'no-cors',
                    signal: controller.signal
                });
                clearTimeout(timeoutId);
                return response.ok || response.type === 'opaque';  // 'opaque' is needed for CORS requests
            } catch (error) {
                clearTimeout(timeoutId);
                if (error.name === 'AbortError') {
                    console.log(`Timeout for ${url}`);
                }
                return false;  // Si une erreur ou timeout, le service est hors ligne
            }
        }

        async function updateDashboard() {
            const container = document.getElementById('services-container');
            container.innerHTML = '';

            // Créer les cartes de services pour tous les services
            services.forEach(service => {
                container.innerHTML += createServiceCard(service);
            });

            // Vérifier le statut de chaque service
            for (const service of services) {
                try {
                    const status = await checkServiceStatus(service.url);
                    const statusElement = document.getElementById(`status-${service.name}`);
                    const statusTextElement = document.getElementById(`status-text-${service.name}`);

                    if (status) {
                        statusElement.className = 'status-dot up';
                        statusTextElement.className = 'status-text up';
                        statusTextElement.textContent = `En ligne - Dernière vérification à ${new Date().toLocaleTimeString()}`;
                    } else {
                        statusElement.className = 'status-dot down';
                        statusTextElement.className = 'status-text down';
                        statusTextElement.textContent = `Hors ligne - Dernière vérification à ${new Date().toLocaleTimeString()}`;
                    }
                } catch (error) {
                    console.error('Erreur lors de la vérification du service:', service.name, error);
                }
            }
        }

        // Mise à jour du dashboard toutes les 5 secondes
        setInterval(updateDashboard, 5000);
        updateDashboard();  // Lancer immédiatement la mise à jour
    </script>
</body>

</html>
