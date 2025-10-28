#!/bin/sh

echo make_flash_image.sh - ImageCreate V2.0.0 Aug.8,2025

export MAKE_IMAGE_PATH=$PWD

export SETTING_BOOTPARAM_PATH=setting/bootparam/
export SETTING_CERT_HEADER_PATH=setting/cert_header/flash/X5H
export SETTING_FLASH_PATH=setting/flash_writer

rm ./output/* -fr
rm ./temp/* -fr

cd $MAKE_IMAGE_PATH/temp
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_BOOTPARAM_PATH/bootparam_image_SA0.txt $MAKE_IMAGE_PATH/temp/bootrom_param.bin
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_CERT_HEADER_PATH/cert_header_image_SA17.txt $MAKE_IMAGE_PATH/temp/cert_header_sa17.bin
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_FLASH_PATH/bootparam_image_fwriter.txt $MAKE_IMAGE_PATH/temp/flash_writer_rsip_m_scif_download.bin

objcopy -I binary -O srec --adjust-vma=0x18400000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/bootrom_param.bin $MAKE_IMAGE_PATH/output/bootparam_image_SA0.srec
objcopy -I binary -O srec --adjust-vma=0x18480000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/cert_header_sa17.bin $MAKE_IMAGE_PATH/output/cert_header_sa17.srec
objcopy -I binary -O srec --adjust-vma=0x18401000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/flash_writer_rsip_m_scif_download.bin $MAKE_IMAGE_PATH/output/flash_writer_rsip_m_scif_download_SB.srec

objcopy -I binary -O srec --adjust-vma=0x18410000 --srec-forceS3 $MAKE_IMAGE_PATH/input/1st_ipl_rsip_m.bin $MAKE_IMAGE_PATH/output/1st_ipl_rsip_m.srec
objcopy -I binary -O srec --adjust-vma=0x3FE00000 --srec-forceS3 $MAKE_IMAGE_PATH/input/App_SCP_X5H_Sample.bin $MAKE_IMAGE_PATH/output/App_SCP_X5H_Sample.srec
objcopy -I binary -O srec --adjust-vma=0x10070000 --srec-forceS3 $MAKE_IMAGE_PATH/input/2nd_ipl_rt_core_cluster2_core0.bin $MAKE_IMAGE_PATH/output/2nd_ipl_rt_core_cluster2_core0.srec