#!/bin/bash -xev

# Create mycron
cat > 'mycron' << EOF
* * * * * chef-client > /tmp/chefclient
EOF
crontab mycron

# Do some chef pre-work
/bin/mkdir -p /etc/chef
/bin/mkdir -p /var/lib/chef
/bin/mkdir -p /var/log/chef

# Setup hosts file correctly
cat >> "/etc/hosts" << EOF
10.0.0.5    compliance-server compliance-server.automate.com
10.0.0.6    infra-server infra-server.automate.com
10.0.0.7    automate-server automate-server.automate.com
EOF

cd /etc/chef/

# Install chef
curl -L https://omnitruck.chef.io/install.sh | bash || error_exit 'could not install chef'

# Create first-boot.json
cat > "/etc/chef/first-boot.json" << EOF
{
   "run_list" :[
   "role[devops]"
   ]
}
EOF

NODE_NAME=node-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)

# Create client.rb
# validation_client_name will be created on chef server need to put name
# validation_key --when client will be created we will get key that name & content needs to be copy in .pem file
cat > '/etc/chef/client.rb' << EOF
log_location            STDOUT
chef_server_url         'https://api.chef.io/organizations/sehg'
validation_client_name  'webserver'                              
validation_key          '/etc/chef/webserver.pem'                #
chef_license            "accept"
node_name               "webserver12"
EOF

# copying key to pem file

cat > '/etc/chef/clientkey.pem' << EOF

-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAu3yJQP7ztCDKtxmpnQsWLeYFkJa1ymH+bEEo/Nh275SLKiBd
e5Az11Y1VLD4zuFaCgb4AledDz128xc2v6BMijSjm2qYMWvLA0gmz65BELpYcDEe
j++X32WDEGG+r09RiqJJ+lvtpVJKkT/GQ2w4YRjJXGzPlkbKlQlSnkjc3gAXVqeT
E+Rh9VIfoKFYin6y8kVBPqHUIQitYRji+bjDv6YiHXNoQFSYjuChbu8vycrhDH9x
v1BBep3g7n74NRQVWTRmF+QCJGA91McRwGfkKqliS5svwfljk5wSEWc4uMySORP9
VMveE068QyjB4Uw4Iwg557LKBsJy9DFYS17xTwIDAQABAoIBADOZidj2kjIQGFqe
WH0dUQRe20c5A11o7PH0WQiFtu4nLsnwUGoyfOIWGuVtM30Urog19MoIPPS10OgE
io/g2U/sPt8GTk7DwQLtN6lO5x9oefCexC+PHHhiYtj+XdG3/dQu6DdcV6J5bIZf
S/zAax/mB31FgTh10UmFYFSp7we1+23095Vjt7enSDQa1MRBbBoDbdlr24K7LAZF
1lsRYEHNfO18k0s6upPo9R7yEsrkNDe9Q2BUlVRpWf83ohs8eXtRf74mqTOfVnHP
xFKTaEElIQma8K6yJU/B07a4n+nFdaoTphXUXJnSlvMJP00DYkrXYfJlwpsxY5k6
rAdKI6kCgYEA89EekW5L5EYghUi9zVWMxYf0I1t2VdIIST+285t5P02VW6ygYPMd
0kWTwHNK39H+Ugh0UAx4W8Pl+OVLpyeXCp+Dz/AVIKMyBCfFtG3WQD2at8vbVtyt
ThXakx9xFinZbKNDLaFnC5UYZDnuro/W/S2k4QE91ONcKnjCjnu+ZsMCgYEAxNrY
DdVoY6KE9fCTwJXsZreThyjKfCDzGIDnWt4d+X47iupaLYa5T41rWdLu9ROBAexr
X4A7RIX75kSW4/Pcm5F+z4ddO22AWGbRVVdXc4UWeDeB0c3o1PTydIisMcSJlkGW
9UqWBf85cPM9MXJDNazv6xA3i1DJ+mIbyKIxWoUCgYEAmAD1x8E1uzklKTMycYM2
YifiQvDQk6x/0frQ+oshSh/6T88NpaOsId2SwdafBW8L2OTAbu93Ue6Nv2Bki++Y
sNzF9qs84L4dfo21KkmX2zEM9i03r62gth/VxwdBH4ozrRET3qzTa1sme8XKUjYG
2IzOUCDQBZtBaJEk6mOnTrUCgYEAraUlxD4lkQ4BHzkR/GXDXHA+0JDo3EnsZgb/
Daa05im1uDo1Rcd7m3Lx6RAp/UExIVM8+8cPgMh3hY2nVHj+drQHGmUblppnBpPb
v94FpD8XrP+5oipyYbeYT7dnvZbSjxpYYRNj9vJF5x6JMh7KroRYNg/eDyQ6poT4
YSjBREkCgYBN1OVMQmy9mpQJ3ede+sOyKGvsq91sbpNnpawrpBCp1/j06hJ2R4BH
R1P8cN9ci1HAUIj5KB2cx93CD9PFffbuBSS4Kv4UjvGAgyUPcLnpJHCVTv7R1rT2
+gO2om5dtLmT8ZSTe+h98dO9kyJ2lfmGnkSrkqXBLqm6cX+8sQhl9Q==
-----END RSA PRIVATE KEY-----
EOF

chef-client -j /etc/chef/first-boot.json



