# add passenger related cronjobs

cat >> /var/spool/cron/crontabs/root << EOF
# additions for mi-qutic-ruby31 image
0 3 * * * rm /var/tmp/buffer.* 2>/dev/null || true
0 4 * * * /usr/bin/find /var/tmp/ -mmin +1440 | /opt/local/bin/grep passenger-error | /usr/bin/xargs /usr/bin/rm
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /usr/bin/mv /tmp/passenger-error* /var/tmp 2>/dev/null || true
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /opt/local/bin/zabbix_passenger >/dev/null 2>&1
EOF

# echo '1,11,21,31,41,51 * * * * if [[ `/opt/qutic/bin/psof --count-numbers-only` -gt 5000 ]]; then /usr/sbin/svcadm restart apache; fi' \
#   >> /var/spool/cron/crontabs/root

# 15 3  * * 0 /usr/sbin/svcadm restart apache