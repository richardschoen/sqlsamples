# Encrypt and decrypt values

These two functions can be used to encrypt and decrypt values   
```
-- Encrypt selected value    
VALUES ENCRYPT_AES256('This is my test', 'mysecret123');   
-- Decrypt the selected value       
VALUES DECRYPT_CHAR(VARBINARY_FORMAT('CCE020FF0025D5A4B96180506FFE4F23B96180506FFE4F234DBD73A96E6D2DDD7456748F14BF4803'), 'mysecret123');   
```
    
    
