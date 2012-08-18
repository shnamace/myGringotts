myGringotts
===========
Overview
===========
This application is designed to store secret and important information such as bank account number and credit card information
in iPhone. Although there are many great applications for this function, most of them are not free and I just wanted
to protect my information via my own application.
myGringotts App http://com.sunghak.myGringotts

AES256 Encryption and Decryption code is derived from RNCryptor, an open source.
Thanks to Rop Napier, a developer of RNCryptor.

Features
===========
If users put title, description, information, key, hint, myGringotts save them in SQLite DB. Key needs to be memoriezed
by users.
Although we could save the information in SQLite DB, for function matter, used file system.

Build
===========
Require Security.framework and RNCyptor Source
RNCyrptor Donwload https://github.com/rnapier/RNCryptor

What is missing
================
Picture, Video, Audio Encryption
Encrypted Information Backup

License
=======
Same Condition with the RNCryptor License

This code is licensed under the MIT License:
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.