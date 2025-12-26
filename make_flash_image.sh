#!/bin/sh

./build_bin_create.sh

echo make_flash_image.sh - ImageCreate V2.0.0 Aug.8,2025

export MAKE_IMAGE_PATH=$PWD

export SETTING_BOOTPARAM_PATH=setting/bootparam/
export SETTING_CERT_HEADER_PATH=setting/cert_header/flash/X5H
export SETTING_FLASH_PATH=setting/flash_writer

rm ./output/* -fr
rm ./temp/* -fr

cd $MAKE_IMAGE_PATH/temp
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_BOOTPARAM_PATH/1st_ipl_secure_boot_certificate.txt $MAKE_IMAGE_PATH/temp/1st_ipl_secure_boot_certificate.bin
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_CERT_HEADER_PATH/images_secure_boot_certificate.txt $MAKE_IMAGE_PATH/temp/images_secure_boot_certificate.bin
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_FLASH_PATH/bootparam_image_fwriter.txt $MAKE_IMAGE_PATH/temp/flash_writer_rsip_m_scif_download.bin

objcopy -I binary -O srec --adjust-vma=0x18400000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/1st_ipl_secure_boot_certificate.bin $MAKE_IMAGE_PATH/output/1st_ipl_secure_boot_certificate.srec
objcopy -I binary -O srec --adjust-vma=0x18480000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/images_secure_boot_certificate.bin $MAKE_IMAGE_PATH/output/images_secure_boot_certificate.srec
objcopy -I binary -O srec --adjust-vma=0x18401000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/flash_writer_rsip_m_scif_download.bin $MAKE_IMAGE_PATH/output/flash_writer_rsip_m_scif_download_SB.srec

objcopy -I binary -O srec --adjust-vma=0x18410000 --srec-forceS3 $MAKE_IMAGE_PATH/input/1st_ipl_rsip_m.bin $MAKE_IMAGE_PATH/output/1st_ipl_rsip_m.srec                                                                                 
objcopy -I binary -O srec --adjust-vma=0x1001C000 --srec-forceS3 $MAKE_IMAGE_PATH/input/configuration_table_a.bin $MAKE_IMAGE_PATH/output/configuration_table_a.srec
objcopy -I binary -O srec --adjust-vma=0x3FE00000 --srec-forceS3 $MAKE_IMAGE_PATH/input/App_SCP_X5H_Sample.bin $MAKE_IMAGE_PATH/output/App_SCP_X5H_Sample.srec
objcopy -I binary -O srec --adjust-vma=0x10070000 --srec-forceS3 $MAKE_IMAGE_PATH/input/2nd_ipl_rt_core_cluster2_core0.bin $MAKE_IMAGE_PATH/output/2nd_ipl_rt_core_cluster2_core0.srec
objcopy -I binary -O srec --adjust-vma=0x18500000 --srec-forceS3 $MAKE_IMAGE_PATH/input/test_rsip_m_lld.bin $MAKE_IMAGE_PATH/output/test_rsip_m_lld.srec
objcopy -I binary -O srec --adjust-vma=0x10200000 --srec-forceS3 $MAKE_IMAGE_PATH/input/test_bare_metal_rt_core_cluster0_core0.bin $MAKE_IMAGE_PATH/output/test_bare_metal_rt_core_cluster0_core0.srec
objcopy -I binary -O srec --adjust-vma=0x11100000 --srec-forceS3 $MAKE_IMAGE_PATH/input/test_bare_metal_rt_core_cluster0_core1.bin $MAKE_IMAGE_PATH/output/test_bare_metal_rt_core_cluster0_core1.srec
objcopy -I binary -O srec --adjust-vma=0x40000000 --srec-forceS3 $MAKE_IMAGE_PATH/input/test_bare_metal_rt_core_cluster1_core0.bin $MAKE_IMAGE_PATH/output/test_bare_metal_rt_core_cluster1_core0.srec
objcopy -I binary -O srec --adjust-vma=0x8E300000 --srec-forceS3 $MAKE_IMAGE_PATH/input/u-boot-elf-ironhide.bin $MAKE_IMAGE_PATH/output/u-boot-elf-ironhide.srec
objcopy -I binary -O srec --adjust-vma=0x8C400000 --srec-forceS3 $MAKE_IMAGE_PATH/input/tee-ironhide.bin $MAKE_IMAGE_PATH/output/tee-ironhide.srec
objcopy -I binary -O srec --adjust-vma=0x8C200000 --srec-forceS3 $MAKE_IMAGE_PATH/input/bl31-ironhide.bin $MAKE_IMAGE_PATH/output/bl31-ironhide.srec
objcopy -I binary -O srec --adjust-vma=0x8AE00000 --srec-forceS3 $MAKE_IMAGE_PATH/input/X5H_NPU0_FW.bin $MAKE_IMAGE_PATH/output/X5H_NPU0_FW.srec
objcopy -I binary -O srec --adjust-vma=0x8B700000 --srec-forceS3 $MAKE_IMAGE_PATH/input/X5H_NPU1_FW.bin $MAKE_IMAGE_PATH/output/X5H_NPU1_FW.srec