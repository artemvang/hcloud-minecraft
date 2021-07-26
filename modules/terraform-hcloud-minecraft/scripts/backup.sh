screen -R mc -X stuff "say Performing backup $(printf '\r')"
screen -R mc -X stuff "save-off $(printf '\r')"
screen -R mc -X stuff "save-all $(printf '\r')"
sleep 3

# Backup

b2 sync --delete --replaceNewer /opt/minecraft/current/world b2://${bucket_name}/backups

# Done
sleep 3
screen -R MC -X stuff "save-on $(printf '\r')"
screen -R MC -X stuff "say Backup complete. $(printf '\r')"
