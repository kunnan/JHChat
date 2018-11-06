//
//  LZSqlCipher.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/22.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef LZSqlCipher_h
#define LZSqlCipher_h

#endif /* LZSqlCipher_h */

/* 数据库密码 */
#define SqlCipher_LeadingColud @"LZ_CFDE43E1-1EF2-4508-9367-2CB25E480857_88CF7644-8931-40E0-A939-642A6074B872"

/*
 
 加密使用说明
 1. Build Settings——>Header Search Paths——>添加 “./sqlcipher/src”
 2. Build Settings——>Other C Flags——>添加 “-DSQLITE_HAS_CODEC”
 
 */


/* 解密说明
 
 数据库解密：
 步骤一：
 安装sqlcipher命令,首先需要安装brew
 1. 在终端输入  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ，按Enter键继续
 2. 提示“Press RETURN to continue or any other key to abort”时，按Enter键继续
 3. 提示”Password”时，输入当前用户开机密码，按Enter键继续
 4. 等待安装成功之后在终端在运行  brew install sqlcipher
 
 步骤二：
 解密目标数据库LeadingCloudMain_V2.db，解密后的数据库为plaintext.db
 1. 使用终端切换到数据库的路径下，命令 cd /Users/xxxxxxx  或 cd (拖动数据库所在文件夹到终端)，按Enter键继续
 2. 切换到数据库所在文件夹之后，输入 sqlcipher LeadingCloudMain_PT.db ，按Enter键继续
 3. 提示“Enter SQL statements terminated with a ";"” 时，
 输入 PRAGMA key = 'LZ_CFDE43E1-1EF2-4508-9367-2CB25E480857_88CF7644-8931-40E0-A939-642A6074B872';
 按Enter键继续
 4. 输入
 ATTACH DATABASE 'plaintext.db' AS plaintext KEY '';
 按Enter键继续
 5. 输入
 SELECT sqlcipher_export('plaintext');
 按Enter键继续
 6. 输入
 DETACH DATABASE plaintext;
 7. 生成的plaintext.db 即为解密后的数据库，可直接打开
 
 */
