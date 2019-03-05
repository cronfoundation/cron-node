#!/usr/bin/expect -f


set wallet [lindex $argv 0]
set password [lindex $argv 1]
set timeout -1

cd /neo-cli
spawn dotnet neo-cli.dll --rpc
expect "neo>"
#send "open wallet $wallet\n"
#expect "password:"
#send "$password\n"
#expect "neo>"
#send "start consensus\n"
#expect "OnStart"
#expect "LIVEFOREVER"
interact
