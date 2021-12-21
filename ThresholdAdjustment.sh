
#-----------------------------------------------------------------------------------------------
# Primary Work
#-----------------------------------------------------------------------------------------------


#Perform BedpostX
echo "Performing Threshold Adjustment"

for H in $Hemispheres; do
 for S in $Structures; do
	${FSLDIR}/bin/fslmaths ${Masks}/r${H}${S}.nii -nan ${Masks}/${H}${S}_nan.nii.gz
	${FSLDIR}/bin/fslmaths ${Masks}/${H}${S}_nan.nii.gz -thr 0.01 ${Masks}/${H}${S}.nii.gz
 done
done


echo "Completed"

