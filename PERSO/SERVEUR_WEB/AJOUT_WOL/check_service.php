<?php
header('Content-Type: application/json');

if (!isset($_GET['url'])) {
    echo json_encode(['status' => false, 'error' => 'No URL provided']);
    exit;
}

$url = $_GET['url'];

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_NOBODY, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 5);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ($response === false || $httpCode == 0) {
    // Pas de réponse ou erreur réseau
    echo json_encode(['status' => false, 'http_code' => $httpCode]);
} else {
    // Considère en ligne si code HTTP est entre 200 et 499 inclus
    $isUp = ($httpCode >= 200 && $httpCode < 500);
    echo json_encode(['status' => $isUp, 'http_code' => $httpCode]);
}

curl_close($ch);
