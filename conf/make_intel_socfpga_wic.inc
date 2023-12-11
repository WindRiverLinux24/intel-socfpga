do_image_wic[postfuncs] += "intel_socfpga_wic"

intel_socfpga_wic() {
	# Create Stratix10 and Agilex wic image separately
	for config in stratix10 agilex; do
		WIC_FULL_NAME=${IMAGE_LINK_NAME}-${config}${IMAGE_VERSION_SUFFIX}${IMAGE_NAME_SUFFIX}
		cd "${DEPLOY_DIR_IMAGE}"

		for file_name in u-boot.img u-boot-dtb.img u-boot.itb; do
			if [ -e ${file_name} ]; then
				rm -rf ${file_name}
			fi
			if [ "$file_name" = "u-boot.itb" ];then
				ln -sf u-boot-${config}-socdk-mmc.itb ${file_name}
			elif [ "$file_name" = "u-boot-dtb.img" ];then
				ln -sf u-boot-dtb-${config}-socdk-mmc.img ${file_name}
			else
				ln -sf u-boot-${config}-socdk-mmc.img ${file_name}
			fi
		done 

		cp ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic ${IMGDEPLOYDIR}/${WIC_FULL_NAME}.wic

		for file_name in u-boot.img u-boot-dtb.img u-boot.itb; do
			wic cp ${file_name} ${IMGDEPLOYDIR}/${WIC_FULL_NAME}.wic:1/
		done

		cd "${IMGDEPLOYDIR}"
		bmaptool create "${WIC_FULL_NAME}.wic" -o "${WIC_FULL_NAME}.wic.bmap"
		ln -sf ${WIC_FULL_NAME}.wic.bmap ${IMAGE_LINK_NAME}-${config}.wic.bmap
		ln -sf ${WIC_FULL_NAME}.wic ${IMAGE_LINK_NAME}-${config}.wic
	done

	# Remove the default wic file
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic.bmap"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic.bmap"
}

BOOTFS_EXTRA_CMD ?= " \
	set -e; \
	for config in stratix10; do \
		old_dir=$(pwd); \
		cd "${DEPLOY_DIR_IMAGE}"; \
		for file_name in u-boot.img u-boot-dtb.img u-boot.itb; do \
			if [ -e ${file_name} ]; then \
			rm -rf ${file_name}; \
			fi; \
			if [ "$file_name" = "u-boot.itb" ];then \
				ln -sf u-boot-${config}-socdk-mmc.itb ${file_name}; \
			elif [ "$file_name" = "u-boot-dtb.img" ];then \
				ln -sf u-boot-dtb-${config}-socdk-mmc.img ${file_name}; \
			else \
				ln -sf u-boot-${config}-socdk-mmc.img ${file_name}; \
			fi; \
		done; \
		mv ${old_dir}/ustart.img ${old_dir}/${config}.ustart.img; \
		for file_name in u-boot.img u-boot-dtb.img u-boot.itb; do \
			wic cp ${file_name} ${old_dir}/${config}.ustart.img:1/; \
		done; \
		cd ${old_dir}; \
		rm -rf ustart.img.bmap; \
		bmaptool create "${config}.ustart.img" -o "${config}.ustart.img.bmap"; \
	done; \
"
