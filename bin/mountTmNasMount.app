-- ##############################
-- change the YOURNNUMBER to your n# if using ETS shared mount
-- Exeute this as a plist/launchd process on network changes to mount drive and start backup
-- ##############################
set serverName to "0055-nas-cl5-c1.lmig.com"
set smbVolumeName to "cifs://0055-nas-cl5-c1/ETS_MacOsX_Backups_NAS_Prod01"
set pathToBackupSparseBundle to "/Volumes/ETS_MacOsX_Backups_NAS_Prod01/backup_n0105464.sparsebundle"
set diskName to "backup_n0105464"
 
 
 
-- ##############################
-- should not need edits past here.....
-- ##############################
do shell script "echo \"Running backup as `whoami` at `date`\">>/tmp/backup.log"
if diskName is in (do shell script "/bin/ls /Volumes") then
    do shell script "echo 'required bundle already mounted, attempting backup'>>/tmp/backup.log"
    runBackup()
else
    if mountPoint is in (do shell script "/bin/ls /Volumes") then
        -- nas is mounted, but our bundle is not, unmount and retry it all
        do shell script "echo 'Found existing NAS without bundle, skipping mount'>>/tmp/backup.log"
        attachVolume(pathToBackupSparseBundle)
        runBackup()
    else
        do shell script "echo 'No drives mounted, pinging NAS server'>>/tmp/backup.log"
        mountNAS(serverName, smbVolumeName)
        attachVolume(pathToBackupSparseBundle)
        runBackup()
    end if
end if
 
on mountNAS(serverName, smbVolumeName)
    set networkUp to true
    try
        do shell script "echo calling " & serverName
        do shell script "ping -c 1 -t 2 " & serverName
    on error
        set networkUp to false
        do shell script "echo 'network not available, abort'>>/tmp/backup.log"
    end try
    if networkUp then
        do shell script "echo 'NAS server available, attempting to mount'>>/tmp/backup.log"
        try
            mount volume smbVolumeName
            delay 10
        on error theError
            do shell script "echo 'FAILED mounting drives or backup'>>/tmp/backup.log"
            return theError
        end try
    end if
end mountNAS
on attachVolume(pathToBackupSparseBundle)
    try
        do shell script "hdiutil attach " & pathToBackupSparseBundle
        delay 10
    on error theError
        do shell script "echo 'FAILED attaching backup drives '>>/tmp/backup.log"
        return theError
    end try
end attachVolume
on runBackup()
    do shell script "tmutil startbackup --auto"
    do shell script "echo 'Backup started!'>>/tmp/backup.log"
end runBackup
