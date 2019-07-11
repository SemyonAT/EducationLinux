# Descrition 


# Quschens
1. Подскажите как в ansible в модуле firewalld добавлять протокол например ospf или такой возможности нет? В тасках роли quaga я использую команду 

firewall-cmd --permanent --zone=public --add-protocol=ospf

2. Подскажите как сохранять правила iptabels правильно, все что чтал в интренете как то через одно место.



# Для себя

iptables -F FORWARD - удалить все правила из цепочки forward
