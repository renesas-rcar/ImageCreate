/*
 * Copyright (c) 2015-2017, Renesas Electronics Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 *   - Neither the name of Renesas nor the names of its contributors may be
 *     used to endorse or promote products derived from this software without
 *     specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define	MAX_READ_SIZE		(64*1024*1024)
#define	MAX_FILE_SIZE		(64*1024*1024)

int main(int argc, char **argv)
{
	FILE *fp;
	FILE *fp2;
	FILE *fp3;
	unsigned char *read_buf;
	unsigned char *write_buf;
	unsigned char *wp;
	char *p;
	char **q;
	size_t read_size;
	size_t write_size = 0;
	char rparam_buf[512];
	char param_filename[512];
	char read_filename[512];
	char write_filename[512];
	char *param[20];
	uint32_t flash_address;

	if (argc < 3) {
		printf("parameter file error\n");
		return -1;
	}
	strcpy(param_filename, argv[1]);
	strcpy(write_filename, argv[2]);

	/* read buffer create */
	read_buf = malloc(MAX_READ_SIZE);
	if (read_buf == NULL) {
		printf("malloc error\n");
		return -1;
	}

	/* write buffer create */
	write_buf = malloc(MAX_FILE_SIZE);
	if (write_buf == NULL) {
		free(read_buf);
		printf("malloc error\n");
		return -1;
	}
	memset(write_buf, 0xff, MAX_FILE_SIZE);
	wp = write_buf;

	/* parameter file open */
	fp3 = fopen(param_filename, "r");
	if (fp3 == NULL) {
		free(read_buf);
		free(write_buf);
		printf("parameter file open error\n");
		return -1;
	} else {
		/* parameter file read */
		memset(rparam_buf, 0x00, sizeof(rparam_buf));
		while (fgets(rparam_buf, sizeof(rparam_buf), fp3) != NULL) {
			if (strlen(rparam_buf) < 3) {
				continue; /* Blank line */
			}
			if (rparam_buf[0] == '#') {
				continue; /* Comment line */
			}
			q = &param[0];
			p = strtok(rparam_buf, " ");
			*q = p;
			q++;
			while (p != NULL) {
				p = strtok(NULL, " ");
				*q = p;
				q++;
			}
			strcpy(read_filename, param[0]);
			flash_address = strtol(param[1], NULL, 16);

			printf("load file    = %s\n", read_filename);
			printf("load address = 0x%08x\n", flash_address);

			/* file read */
			fp2 = fopen(read_filename, "rb");
			if (fp2 == NULL) {
				free(read_buf);
				free(write_buf);
				printf("%s open error\n", read_filename);
				return -1;
			}

			read_size = fread(read_buf, 1, MAX_READ_SIZE, fp2);
			fclose(fp2);
			printf("load_size    = %zd\n", read_size);
			if (read_size < 1) {
				free(read_buf);
				free(write_buf);
				printf("%s read error\n", read_filename);
				return -1;
			}
			wp = write_buf + flash_address;
			memcpy(wp, read_buf, read_size);
			if (write_size < (flash_address + read_size)) {
				write_size = (flash_address + read_size);
			}
		}
	}
	fclose(fp3);

	/* file write */
	free(read_buf);

	fp = fopen(write_filename, "wb");
	if (fp == NULL) {
		free(write_buf);
		printf("target file open error\n");
		return -1;
	}
	write_size = fwrite(write_buf, write_size, 1, fp);
	free(write_buf);
	fclose(fp);
	if (write_size == 0) {
		printf("target file write error\n");
		return -1;
	}

	return 0;
}
