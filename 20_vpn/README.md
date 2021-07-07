#Task
VPN
1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3*. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

# Description 

Схема работы
office1Router - центр сертификации
centralRouter - open vpn client
office1Router - open vpn server

генерация сертификатов была выполненна блоком ease-rsa комманды которыми была выполненны записаны в роли openSSL ansible
центр сертификации выполнял office1Router.

Тоннель поднимается коммандами ниже.
systemctl start openvpn-server@server
systemctl start openvpn-server@client

tun и tap отличаются тем что один бридж l2 level, другой l3 level, и от этого на l3 связонности могут неработать низкоуровневые протоколы.

На моем стенде все получилось ниже привожу пример комманды ip a и пинг с клиента на сервер

//client
8: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none 
    inet 10.15.0.2/24 brd 10.15.0.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::47bb:6af2:1e51:d3/64 scope link flags 800 
       valid_lft forever preferred_lft forever
[root@centralRouter ~]# ping 192.68.0.1
PING 192.68.0.1 (192.68.0.1) 56(84) bytes of data.
^C
--- 192.68.0.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4009ms

[root@centralRouter ~]# ping 10.15.0.1
PING 10.15.0.1 (10.15.0.1) 56(84) bytes of data.
64 bytes from 10.15.0.1: icmp_seq=1 ttl=64 time=1.06 ms
64 bytes from 10.15.0.1: icmp_seq=2 ttl=64 time=1.27 ms
64 bytes from 10.15.0.1: icmp_seq=3 ttl=64 time=1.13 ms
^C

//server
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none 
    inet 10.15.0.1/24 brd 10.15.0.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::bd6c:7f54:778c:da03/64 scope link flags 800 
       valid_lft forever preferred_lft forever


# Quschens

Подскажите как обычно организовывают vpn тоннель между дата центрами, просто определяют кто будет клиентом кто сервером или организовывают двухсторонюю связь и оба маршрута роутят