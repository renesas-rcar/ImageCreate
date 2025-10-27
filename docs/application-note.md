# 1. Overview  
---  
## 1.1. Overview  
This document explains the "ImageCreate".  
The "ImageCreate" is sample software for combining data placed at various offsets within a sector of the flash memory.  

Chapter 2 shows the operating environment.  
Chapter 3 describes the execution procedure.  
Chapter 4 explains the configuration.  

## 1.2. Related Documents  
[1] Initial Program Loader for R-Car series, 5th Generation User's Manual:Software  

## 1.3. Restrictions  
There is no restriction in this revision.  

# 2. Operating Environment  
---  
This sample software was confirmed to operate normally in the Ubuntu 24.04 LTS (64 bit) environment.  

# 3. Execution Procedure  
---  
## 3.1. build the "bin_create"  
If you have not yet built the "bin_create", then execute the "build_bin_create.sh".

```  
~/ImageCreate $ ./build_bin_create.sh  
```  

If successfully built, the "bin_create" will be stored in the "bin" folder.  
The "bin_create" is combine the binary data, according to specified two arguments.  

**./bin/bin_create configuration-file combined-filename**  

For first argument "configuration-file", specify the configuration file of data file structure.  
Refer to chapter 4 for the configuration file of data file structure details.  
For second argument "combined-filename", specify the data file name of combine result.  

## 3.2. Create the combined file  
If you execute the following command, then the combined file is created.  

```  
~/ImageCreate $ ./make_flash_image.sh  
```  

In the "make_flash_image.sh", the "bin_create" and the objcopy is executed.  
The "bin_create" combines binary data, and the objcopy converts from binary format to s-record format.  

As result of execution, following files are output to the "output" folder.  

- **bootparam_sa0.srec**  
- **cert_header_sa17.srec**  

In "make_flash_image.sh", samples for combining parameter sets referenced from the BootROM and the IPL are set as defaults.  
These parameter sets are example for booting the IPL on the execution environment (target board).  
The BootROM is the boot rom of the IPL execution environment (target board), and it is boot the IPL.  
The link to the IPL is shown in clause 1.2 Related Documents a).  

# 4. Configuration  
---  
## 4.1. The configuration file of data file structure  
The configuration file of data file structure is specified by first argument of the "bin_create".  
The default setting of the "make_flash_image.sh" is specified as follows.  

**setting/bootparam/bootparam_image_SA0.txt**  
**setting/cert_header/flash/X5H/cert_header_image_SA17.txt**  

The configuration file of data file structure is very simple.  
Just specify the data file and offset to be combined on each line.  

When "make_flash_image.sh" is executed, data is combined with the combined file as follows.  

1. The "bin_create" reads one line of the configuration file of data file structure.  
2. Reads the file specified in the read line and stores it in the offset position of the Combined file.  
3. Repeat steps 1 and 2 until all lines of the Configuration file of data file structure have been read.  

The configuration file of data file structure is specified by first argument of the "bin_create".  

Combined file name is specified by second argument of the "bin_create".  

The "bin_create" is executed from the "make_flash_image.sh".  

## 4.2. Store the data files  
Before executing the "make_flash_image.sh", store the data files to be combined.  

## 4.3. Default configuration  
In the "cert_header_image_SA17.txt", the parameters set for each line are as follows the X5H Memory Map.
The setting values and the data structure may differ depends version of the IPL.  

For details, refer to the Related Documents [1].  

## 4.4. Points to note when create/update the Configuration file  
- Must describe the data file path from beginning of the line.  
- The data file is read as raw binary data.  
- Only the "space" character (ASCII 0x20) can be written between data file and offset. (The Tab character (ASCII 0x09) cannot be used)  
- Lines beginning with # are treated as empty lines. (Available as comments)  
- The gap (the part where data is not specified by the configuration of data structure) of the combined data is filled with 0xFF.  
- Overlapping due to offset and read data size is not checked.  