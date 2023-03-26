These scripts configure wireguard vpn server and wireguard vpn clients(peers).
You should run 'wg-server-init-setup.sh' and 'wg-server-final-setup.sh' scripts on the server.
You should run 'wg-client-setup.sh' on your client.

Before executing the scripts, you need to establish ssh connection between server and clients.

You should call the first script 'wg-server-init-setup.sh' without any adjustments.

Before running the scripts you have to specify some variables in 'wg-client-setup.sh' and 'wg-server-final.sh':
  - client_user - user under whom you run this script on a client machine
  - server_user - user under whom you connect to the server machine via ssh
  - clinet - name of client, for exemple 'clien1, client2 ...'
  - client_ip - IPv4 address of your client, you can choose any from 10.8.0.2-10.8.0.254 range for every client
  - ip_vpn_server - public ip of your server machine
  - ip_dns_resolver - public ip of dns resolver of vpn server, you can find it out running 'ip route list default' on your server 

For every client run 'wg-client-setup.sh' on client machine, then run 'wg-server-final.sh' on the server with client's configuration.
Do not run more than once 'wg-server-init-setup.sh'.


