#! usr/bin/bash

###########################################################
#   7) WebOstatu birtuala sortu.
###########################################################

function sortuWebOstatu(){
#weba kudeatzeko katalogoaren egikariketa
	egoera=`ls /var/www | grep -c 'foroa'`
	egoeras=`ls /var/www/foroa | grep -c 'public'
	if [ -z '$egoera' ]
	then
		sudo mkdir /var/www/foroa
	fi

	if [ -z '$konprobaketaS' ]

		sudo mkdir /var/www/foroa/public
	fi

	sudo chgrp www-data /var/www/foroa #baimenak eman foroa taldean 
	sudo usermod -a -G www-data $USER #erabiltzailea taldean sartu

#baimenen esleipena
	sudo chmod -R 775 /var/www/foroa
	sudo chmod -R g+s /var/www/foroa
	sudo chown -R $USER /var/www/foroa #jabetza eman erabiltzaileari


#konfigurazio fitxategiak
	sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/foroa.conf
	sudo sed -i 's%:80%:8080%g' /etc/apache2/sites-available/foroa.conf
	sudo sed -i 's%html%foroa/public%g' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '29i <Directory /var/www/foroa/public>' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '30i Options Indexes FollowSymLinks MultiViews' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '31i ALlowOverride All' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '32i Order allow,deny' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '33i allow from all' /etc/apache2/sites-available/foroa.conf
	sudo sed -i '34i </Directory>' /etc/apache2/sites-available/foroa.conf

#apache portuen irekiera
	egoerak=`grep -c 'Listen 8080' /etc/apache2/ports.conf`
	if [ -z '$egoerak' ]
	then
		sudo sed -i 's%Listen 80%Listen 8080%' /etc/apache2/ports.conf
	fi

#virtualHost berria bideratu
	egoerab=`ls /etc/apache2/sites-available | grep -c 'foroa.conf'`
	if [ -z '$egoerab' ]
	then
		sudo ln -s /etc/apache2/sites-available/foroa.conf /etc/apache2/sites-available/foroa.conf
	fi
	sudo systemctl restart apache2 


#egiaztaketa
	touch /var/www/foroa/public/index.html
	echo <title> Konprobaketa </title> | tee /var/www/foroa/public/index.html 1>dev/null
	sudo firefox http://localhost:8080/index.html
}
