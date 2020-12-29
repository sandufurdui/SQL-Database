USE master; 
 
GO  
BACKUP DATABASE universitatea  
TO DISK = 'D:\Backup_lab11\exercitiul1.Bak'  
WITH FORMAT 
GO  
BACKUP LOG universitatea TO DISK = 'D:\Backup_lab11\exercitiul1.Bak'


GO  
BACKUP DATABASE universitatea  
TO DISK = 'D:\Backup_lab11\exercitiul2.Bak'  
WITH DIFFERENTIAL 
GO  
BACKUP LOG universitatea TO DISK = 'D:\Backup_lab11\exercitiul2.Bak'

GO
BACKUP LOG universitatea  
   TO DISK = 'D:\Backup_lab11\exercitiul3.Bak'
GO  

use universitatea_1
RESTORE FILELISTONLY  
   FROM DISK = 'D:\Backup_lab11\exercitiul1.Bak';  
RESTORE DATABASE universitatea1  
   FROM DISK = 'D:\Backup_lab11\exercitiul1.Bak';  
