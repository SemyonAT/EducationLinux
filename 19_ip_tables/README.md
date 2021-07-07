# Descrition 

1. Сдлал в начале проброску пота 80 с inetRouter2 на centralServer где был поднят nginx
2. Настроил ssh на inetRouter через knock skript с помощью iptabels использую ansible и модуль из интеренета iptabels_row

# Quschens
1. Подскажите как в ansible в модуле firewalld добавлять протокол например ospf или такой возможности нет? В тасках роли quaga я использую команду shell

firewall-cmd --permanent --zone=public --add-protocol=ospf
