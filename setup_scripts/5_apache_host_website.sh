#! /bin/bash
if [ $# -lt 1 ]; then 
    echo
    echo " USAGE : "
    echo
    echo " ./apache_host_website <domain_name>"
    echo
    exit 1
fi

echo 

DOMAIN_NAME="$1"
DOMAIN_CONF="${DOMAIN_NAME}.conf"
DOCUMENT_ROOT="/var/www/${DOMAIN_NAME}"
HTML_PAGE="$DOCUMENT_ROOT/index.html"

a2dissite $DOMAIN_CONF &> /dev/null 
service apache2 restart

rm -rf "/etc/apache2/sites-available/$DOMAIN_CONF"
rm -rf $DOCUMENT_ROOT
rm -rf $HTML_PAGE

cd /etc/apache2/sites-available/
ls 000-default.conf &> /dev/null
if [ $? -ne 0 ]; then
    echo
    echo "error: 000-default.conf not available"
    echo 
    exit 1
fi

a2dissite 000-default.conf &> /dev/null
if [ $? -ne 0 ]; then
    echo
    echo "error: unable to disable  000-default.conf"
    echo 
    exit 1
fi

service apache2 restart

touch "/etc/apache2/sites-available/$DOMAIN_CONF"

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to create file (/etc/apache2/sites-available/$DOMAIN_CONF)"
    echo 
    exit 1
fi


cat > "/etc/apache2/sites-available/$DOMAIN_CONF" <<EOF
<VirtualHost *:80>
ServerName $DOMAIN_NAME
ServerAlias www.$DOMAIN_NAME
DocumentRoot /var/www/$DOMAIN_NAME/
</VirtualHost>
EOF
#Keep in mind there should not be any space after EOF

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to add content to ( $DOMAIN_CONF )"
    echo 
    exit 1
fi


mkdir $DOCUMENT_ROOT

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to create directory ( $DOCUMENT_ROOT )"
    echo 
    exit 1
fi


touch $HTML_PAGE

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to create file( $HTML_PAGE )"
    echo 
    exit 1
fi


cat > $HTML_PAGE <<EOF
<html>
<head><title>$DOMAIN_NAME</title></head>
<body>
<h1>$DOMAIN_NAME</h1>
</body>
</html>
EOF
#Keep in mind there should not be any space after EOF

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to add content to ( $HTML_PAGE )"
    echo 
    exit 1
fi


a2ensite "${DOMAIN_NAME}.conf" &> /dev/null

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to enable site ( ${DOMAIN_NAME}.conf )"
    echo 
    exit 1
fi

echo "[ STATUS  ] remove stale configuration"
sed -i "/127.0.0.1 $DOMAIN_NAME/d" /etc/hosts

echo "127.0.0.1 $DOMAIN_NAME" >> /etc/hosts

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to add content to ( /etc/hosts )"
    echo 
    exit 1
fi


service apache2 restart

if [ $? -ne 0 ]; then
    echo
    echo "error: unable to restart apache2 server"
    echo 
    exit 1
fi

echo "[ SUCCESS ] Website Is Configured for ( $DOMAIN_NAME )"
echo 
echo 
echo " ############## WEBSITE HOSTING DETAILS ##############" 
echo 
echo 
echo "       Website Config -> /etc/apache2/sites-available/$DOMAIN_CONF"
echo 
echo "       Document Root  -> ${DOCUMENT_ROOT}/"
echo 
echo 
echo " ############## WEBSITE HOSTING DETAILS ##############" 
echo 
echo 
