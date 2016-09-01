#!/bin/sh

echo make_flash_image.sh - ImageCreate V1.00 Apr.27,2017

export MAKE_IMAGE_PATH=$PWD

#export SETTING_BOOTPARAM_PATH=setting/bootparam/v1
export SETTING_BOOTPARAM_PATH=setting/bootparam/v2
#export SETTING_CERT_HEADER_PATH=setting/cert_header/flash/v1
export SETTING_CERT_HEADER_PATH=setting/cert_header/flash/v2
#export SETTING_CERT_HEADER_PATH=setting/cert_header/emmc/v1

rm ./output/* -fr
rm ./temp/* -fr

cd $MAKE_IMAGE_PATH/temp

$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_BOOTPARAM_PATH/bootparam_image_SA0.txt $MAKE_IMAGE_PATH/temp/bootparam_sa0.bin
$MAKE_IMAGE_PATH/bin/bin_create $MAKE_IMAGE_PATH/$SETTING_CERT_HEADER_PATH/cert_header_image_SA6.txt $MAKE_IMAGE_PATH/temp/cert_header_sa6.bin

objcopy -I binary -O srec --adjust-vma=0xE6320000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/bootparam_sa0.bin $MAKE_IMAGE_PATH/output/bootparam_sa0.srec
objcopy -I binary -O srec --adjust-vma=0xE6320000 --srec-forceS3 $MAKE_IMAGE_PATH/temp/cert_header_sa6.bin $MAKE_IMAGE_PATH/output/cert_header_sa6.srec
