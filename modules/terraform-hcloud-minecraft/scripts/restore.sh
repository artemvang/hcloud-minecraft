screen -R mc -X stuff "say Performing restore $(printf '\r')"
screen -R mc -X stuff "save-off $(printf '\r')"
screen -R mc -X stuff "save-all $(printf '\r')"
sleep 3

# Backup

b2 sync --delete --replaceNewer b2://${bucket_name}/backups /opt/minecraft/current/world

# Done
sleep 3
screen -R MC -X stuff "save-on $(printf '\r')"
screen -R MC -X stuff "say Restore complete. $(printf '\r')"
