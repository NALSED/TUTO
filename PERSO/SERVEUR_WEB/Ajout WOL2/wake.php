<?php
function wake_on_lan($mac) {
    $mac_bytes = explode(':', $mac);
    $hw_addr = '';

    foreach ($mac_bytes as $byte) {
        $hw_addr .= chr(hexdec($byte));
    }

    $packet = str_repeat(chr(0xFF), 6) . str_repeat($hw_addr, 16);

    $sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
    socket_set_option($sock, SOL_SOCKET, SO_BROADCAST, true);

    // Adresse de broadcast du réseau local
    $broadcast = '192.168.0.255';
    $port = 9;

    socket_sendto($sock, $packet, strlen($packet), 0, $broadcast, $port);
    socket_close($sock);
}

$mac_address = '50:3E:AA:06:DA:D1'; // Adresse MAC cible
wake_on_lan($mac_address);

echo "Machine réveillée (paquet envoyé à $mac_address)";
?>
