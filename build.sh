###########################
####### FILES SETUP #######
###########################

# $1 = machine name;
# setupDirs pc1
setupDirs(){
	mkdir -p $1/etc/
	echo -n > $1.startup
}

###########################
####### DINAMIC ROUTING  #######
###########################

startZebra(){
	echo "/etc/init.d/zebra start">>$1.startup
	mkdir $1/etc/zebra
}

setupZebraOSPF(){
	cp z_ospf.conf $1/etc/zebra/ospfd.conf
        cp z_daemonsOSPF $1/etc/zebra/daemons
}

setupZebraRIP(){
	cp z_ripd.conf $1/etc/zebra/ripd.conf
	cp z_daemonsRIP $1/etc/zebra/daemons
}

setupZebraBOTH(){
	cp z_ripd.conf $1/etc/zebra/ripd.conf
	cp z_ospf.conf $1/etc/zebra/ospfd.conf
        cp z_daemonsBOTH $1/etc/zebra/daemons
}

#################################
####### ROUTING FUNCTIONS #######
#################################

# $1 = file to write;
# $2 = interface name;
# $3 = interface ip;
# $4 = interface netmask;
# S5 = interface broadcast;
# addInterface pc1 0 192.168.2.3 /24 192.123.12.122
# addInterface pc1 0 192.168.1.1/24
addInterface () {
	if [ -n $4 ]; then
    		echo "ifconfig" "eth"$2 $3 "up">> $1.startup
   	else
    		echo "ifconfig" "eth"$2 $3 "netmask" $4 "broadcast" $5 "up">> $1.startup 	   
   	fi
}

# $1 = file to write
# $2 = interface
# $3 = net
# $4 = netmask
# $5 = destination (interface ip)
# addStaticRoute pc1 0 200.10.10.0 200.10.10.1
addStaticRoute() {
	echo "route add -net $3 gw $4 dev eth$2" >> $1.startup	
}

# $1 = file to write
# $2 = interface
# $3 = destination (interface ip)
# addDefaultGW pc1 0 200.10.10.2
addDefaultGW(){
	echo "route add default gw $3 dev eth$2" >> $1.startup	
}


####################################
####### WEB SERVER FUNCTIONS #######
####################################

setupWS(){ 
	echo "a2enmod userdir">>$1.startup
	mkdir -p $1/home/guest/public_html
    	echo "a2enmod rewrite">>$1.startup
    	echo "/etc/init.d/apache2 start">>$1.startup
}

# ricordati di avviare il processo solo dopo aver attivato eventuali moduli /etc/init.d/apache2 start
# modulo enmod userdir -> permette di servire pagine ip/~username/
#	le mappa alla cartella /home/username/public_html
# 	il modulo è configurabile in file /etc/apache2/mods-enabled/userdir.conf  
#	probabile che non funzioni, soluzione: "UserDir public_html" in "UserDir /home/*/public_html\" conf del modulo  
#	collabora con il file public_html/.htaccess con le istruzioni principali:
#		"Deny from ip/mask" -> non fa accedere dall'ip
#		"DirectoryIndex altrapagina.html" -> se accedo alla root non carica indice ma questa pagina.


#############################
####### DNS FUNCTIONS #######
#############################

# chiedi al proffe se le configurazioni della triade va completamente oscurata.

# Assign to machine $1 a defatult nameserver $2 [ for domain name $3 ]
addLocalNS(){
	echo "nameserver" $2 > $1/etc/resolv.conf
  	if [ ! -n $3 ]; then
    		echo "search" $3 >> $1/etc/resolv.conf
  	fi
}

# At machine $1's startup start bind service
setupNS(){
	mkdir -p $1/etc/bind
	echo "/etc/init.d/bind start">>$1.startup
	echo "TODO: add configs for NS $1"
}	

#################################
####### GENERIC FUNCTIONS #######
#################################
labconf(){
	if [  !  -e lab.conf  ]; then
    		for var in "$@"
  		do
			echo  "$var[mem]=32" >> lab.conf
  		done
  		echo -e "\n">>lab.conf
  		for var in "$@"
  		do
			echo -e "$var[0]=\n\n" >> lab.conf
  		done	
	fi
}

bye(){
	echo -e "Edit lab.conf, start the lab and have a good Testing ... "
	echo -e "Bye... "
	echo -e "\t\t\t ¯\_(ツ)_/¯ "
	echo -e "\t\t\t\t\t\t ...MtNnTn"
}

######################### SETUP YOUR LAB #########################

##### cleaning #####

##### lab #####






############################# END ################################
bye
