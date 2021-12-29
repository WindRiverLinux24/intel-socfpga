do_image_wic[postfuncs] += "intel_socfpga_wic"

intel_socfpga_wic() {
	# Create Stratix10 and Agilex wic image separately
	for config in stratix10 agilex; do
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

		cp ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-${config}.wic

		for file_name in u-boot.img u-boot-dtb.img u-boot.itb; do
			wic cp ${file_name} ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-${config}.wic:1/
		done

		cd "${IMGDEPLOYDIR}"
		bmaptool create "${IMAGE_LINK_NAME}-${config}.wic" -o "${IMAGE_LINK_NAME}-${config}.wic.bmap"
	done

	# Remove the default wic file
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.wic.bmap"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic"
	rm -rf "${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic.bmap"
}
