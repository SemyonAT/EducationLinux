# Скрипт сборки #

Скрипт проверяет создан в системе рэйд или нет, и если не создан, то создает его.

В процессе создания рэйда для обучения добавлен механизм удаления одного диска и обратного подключения. Устанавливаются паузы для того, чтобы массив успел восстановится.

Происходит контроль состояния рэйда и если он собран, то происходит создание файловой системы, форматирование массива и автоматическая регистрация в fstab для автоматического монтирования.

# Vagrant file #

В вагрант фале добавлен копирование скрипта в каталог /home/vagrant/bin и организован запуск его

# Задание с ** 
выбрал конфигурацию с uefi и дисками nvme по причине того что мне скоро это предстоит делать на прод среде. 

1. Установил centos 7 на virtualbox c uefi на один жесткий диск. Ещё в систему подключено 2 диска nvme. Будет настроен первый рэйд после диск на который установлена система будете отключен. 
2. выполняю команду lsblk

	![lsblk](/02_Disk/lsblk_ferst_uefi.JPG)

3. На дополнительных двух дисках NVMe собираю raid, перед разбиваю на 4 раздела (boot, uefi, root fs, swap) диски. Все соответствующим образом форматирую:
	`mdadm --create --verbose /dev/md0 -l 1 -n /dev/nvme0n1p1` 
	* md0 (EFI system Partition) vfat (fat 16) 210Mb
	* md1 (boot раздел) ext2 1000Mb
	* md3 linux-swap (1000Mb)
	* md4 root fs ext4 
	* все разделы помечаю как gpt, uefi умеет работать с ними
	* Создаю конфигурационный файл райда
		* echo "DEVICE partitions" > /etc/mdadm.conf
		* mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
4. Создаю каталог будущего root fs
	
	`sudo mkdir /raid`
5. Монтирую в каталог диск md3
	`sudo mount /dev/md3 /raid` 
	
6. в него копирую корень
	
	`sudo rsync -aux / /raid/`
7. Монтирую раздел Boot и uefi

	`sudo mount /dev/md1 /raid/boot`  
	`sudo rsync -aux /boot /raid`   
	`sudo mount /dev/md0 /raid/boot/efi`      
	`sudo rsync -aux /boot/efi /raid/boot/`
		
8. Монтирую системные каталоги новому корню 

	`sudo mount --bind /proc /raid/proc && sudo mount --bind /dev /raid/dev && sudo mount --bind /sys /raid/sys && sudo mount --bind /run /raid/run`

9. захожу в новую среду

	`sudo chroot /raid`
10. Редактирую fstab

	![fstab](/02_Disk/fstab_new.JPG)

11. Меняю в файле /etc/default/grub строку GRUB_CMDLINE_LINUX

	![/etc/default/grub](/02_Disk/grub.JPG)

12. В среде chroot генерирую config GRUb2
	
	`#grub2-mkconfig -o /etc/grub2.cfg (/boot/grub2/grub.cfg)`
	`grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg`

13. Устанавливаю GRUB2 на оба диска NVME
	
	`sudo yum install grub2-efi-modules`  
	`sudo yum install efibootmgr`   
	`grub2-install /dev/nvme0n1p2 --boot-directory /boot --efi-directory=/boot/efi`    
	`grub2-install /dev/nvme0n2p2 --efi-directory=/boot/efi`

14. Просматриваем конфигурацию uefi 

	`efibootmgr -v`
15. Переконфигурируем inird

	`dracut -f -v`

16. efibootmgr -c -d /dev/nvme0n2 -p 1 -L "Centos Linux R2" -l \\EFI\\centos\\grubx64.efi

17. В virtual box убираю основной диск и система грузится только с райда. Скриншот комманды lsblk ниже

	![lsblk finish](/02_Disk/finish.JPG)



# Не для проверки

 
 grub-install /dev/sda

Установка Grub efi на MBR все выглядит точно так же, только тут есть несколько ограничений. Раздел ESP нужно создавать только в начале диска. В режиме EFI тоже можно установить GRUB на флешку, и это не очень сложно. Для этого используется команда:

 grub-install --boot-directory=/mnt/sdb2/boot --efi-directory=/mnt/sdb1 --target=x86_64-efi --removable

Рассмотрим опции: --boot-directory - задает папку с файлами загрузчика на флешке, --efi-directory - папка куда смонтирован раздел efi, --target - архитектура целевой системы и --removable говорит, что это установка на съемный носитель. С UEFI все. После перезагрузки и выбора в меню EFI пункта связанного с Grub, вы получите доступ к привычному меню grub и сможете выбрать нужный параметр.