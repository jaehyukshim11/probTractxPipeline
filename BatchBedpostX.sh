
#-----------------------------------------------------------------------------------------------
# Primary Work
#-----------------------------------------------------------------------------------------------


#Perform BedpostX
echo "Performing bedpostX"
${FSLDIR}/bin/bedpostx_gpu ${Folder} --nf=3 --fudge=1  --bi=3000 --nj=1250 --se=25 --model=3 --cnonlinear --rician -g

echo "BedpostX folder generated at ${Folder}.bedpostX"

XTBed="${Folder}.bedpostX"


echo "Completed"

