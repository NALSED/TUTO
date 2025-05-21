# Ce document à pour but la syntaxe des routes sur cisco

# INFRA

![image](https://github.com/user-attachments/assets/2d5482c5-5909-41b7-a488-0f82d9022fdc)

<details>
<summary>
<h2>
:arrow_forward: IPv4 et IPv6 du Lab  
</h2>
</summary>

### Réseau 1 

* ####  192.168.1.0/24

* #### 2001:db8:f3c1:1::/64

|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|pc |192.168.1.10/24|2001:db8:1::10/64|
|pc|192.168.1.11/24|2001:db8:f3c1:1::11/64|
|pc|192.168.1.12/24|2001:db8:f3c1:1::12/64|




### Réseau 2

* ####  192.168.2.0/24

* #### 2001:db8:f3c1:2::/64

|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|pc |192.168.2.10/24|2001:db8:f3c1:2::10/64|
|pc|192.168.2.11/24|2001:db8:f3c1:2::11/64|





### Réseau 3

* ####  192.168.3.0/24

* #### 2001:db8:f3c1:3::/64

|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|pc |192.168.3.10/24|2001:db8:f3c1:3::10/64|


### Réseau 4

|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|Gig0/2_R0|192.168.4.1/30|FE80::290:CFF:FE02:3703|
|Gig0/2_R1|192.168.4.2/30|FE80::230:F2FF:FE77:6203|




### `R0`
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|Gig 0/0|192.168.1.1/24|2001:db8:f3c1:1::1/64 |
|Gig 0/1|192.168.2.1/24|2001:db8:f3c1:2::1/64|
|Gig 0/2|192.168.4.2/30|FE80::290:CFF:FE02:3703/64|





### `R1`

|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|Gig 0/0 |192.168.3.1/24|2001:DB8:F3C1:3::1/64|
|Gig 0/2|192.168.4.2/30|FE80::230:F2FF:FE77:6203/64|




</details>


#### Après configuration des IPv4 et IPv 6 sur les routeur, configuration des routes

#### `SYNTAXE`
* #### IPv4 R(config)# ip route <IP><CIDR><GATEWAY>
          R(config)# 192.168.0.10 255.255.255.0 192.168.4.1
          
* #### IPv6 R(config)# ipv6 route <IP><CIDR><INTERFACE><GATEWAY(ip de l'interface <=)>
          R(config)# <2001:db8:f3c1:1::1/64> <gigabitEthernet 0/2> <FE80::290:CFF:FE02:3703/64>


### `R0`

        R0(config)# ip route 192.168.3.0 255.255.255.0 192.168.4.1
        R0(config)# ipv6 route 2001:db8:f3c1:3::10/64 gigabitEthernet 0/2 FE80::230:F2FF:FE77:6203/64
        R0(config)#do wr

### `R1`

      R1(config)#ip route 192.168.1.0/24 255.255.255.0 192.168.4.2
      R1(config)#ip route 192.168.2.0 255.255.255.0 192.168.4.2
      R1(config)#ipv6 route 2001:db8:f3c1:1::/64 gigabitEthernet 0/2 FE80::230:F2FF:FE77:6203
      R1(config)#ipv6 route 2001:db8:f3c1:2::/64 gigabitEthernet 0/2 FE80::230:F2FF:FE77:6203
      R1(config)#do wr 


## A présent le ping est possible entre 192.168.1.12 et 192.168.3.10








