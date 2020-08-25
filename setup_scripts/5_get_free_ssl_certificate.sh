if [ $# -lt 2 ]; then 
    echo
	echo " [ USAGE ] "
    echo
	echo "       ./5_get_free_ssl_certificate.sh <domain_name> <email_address>"
    echo
	echo
	exit 1
fi

which certbot 2> /dev/null
if [ $? -ne 0 ]; then
	echo 
	echo " [ ERROR ] certbot utility not found"
	echo
	exit 1
fi

DOMAIN_NAME="$1"
EMAIL_ADDRESS="$2"

echo " [ STATUS ] Generating Certificate For ( $DOMAIN_NAME )"
echo " [ STATUS ] Email Address ( $EMAIL_ADDRESS )"

certbot --apache -m $EMAIL_ADDRESS -d $DOMAIN_NAME --non-interactive --agree-tos

echo " [ STATUS ] Generated Certificates Are Located @ (/etc/letsencrypt/archive) (/etc/letsencrypt/live)"
