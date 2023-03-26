This scripts configure wireguard vpn server and wireguard vpn clients(peers).
You should to run 'wg-server-init-setup.sh' and 'wg-server-final-setup.sh' scripts on the server.
You should to run 'wg-client-setup.sh' on your client.

Before executing the scripts, you need to establish ssh connection between server and clients.

First script 'wg-server-init-setup.sh' you should to run without any adjustings.

Before running the scripts you have to specify some variables in 'wg-client-setup.sh' and 'wg-server-final.sh':
  - client_user - user under whom you run this script on a client machine
  - server_user - user under whom you connect to the server machine via ssh
  - clinet - name of client, for exemple 'clien1, client2 ...'
  - client_ip - IPv4 address of your client, you can choose any one from 10.8.0.2-10.8.0.254 range
  - ip_vpn_server - public ip your server machine
  - ip_dns_resolver - public ip of dns resolver for you vpn server, you can find it out running 'ip route list default' on your server if you get more then one dns resolver, pick any

For every client run 'wg-client-setup.sh' on client machine, and then run 'wg-server-final.sh' on the server with clients configuration.
Do not run more than once 'wg-server-init-setup.sh'.


