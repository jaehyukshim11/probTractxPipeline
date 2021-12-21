XTBed="${Folder}.bedpostX"

echo $Folder
echo "Number of Samples=$NSamples"
echo "Curvature Threshold=$Curv"
echo "Number of Steps=$NSteps"
echo "Step Length=$SLength"
echo "Volume Threshold=$FThresh"
echo "Folder Name for this run=$FolderName"

FolderName="/${FolderName}"

mkdir ${XTBed}${FolderName}
PRun=${XTBed}${FolderName}
mkdir ${PRun}/AllPaths
printf '%s\n' "Number of Samples=$NSamples" "Curvature Threshold=$Curv" "Number of Steps=$NSteps" "Step Length=$SLength" "Volume Threshold=$FThresh" "Folder Name for this run=$FolderName" >> ${PRun}/RunParameters.txt

#Intra-hemisphere PROBTRACKX (Left-Left, Right-Right)
for XHemisphere in ${Hemispheres}; do

for YHemisphere in ${Hemispheres}; do

if [ "${XHemisphere}" == "${YHemisphere}" ] ; then

for StructureA in ${Structures}; do
		echo ""
		echo ""
		echo ""


		echo "Seed Mask is ${StructureA}"

		for StructureB in ${Structures}; do

		echo "Target Mask is ${StructureB}"
			
		echo "Processing ${XHemisphere} ${StructureA} ${StructureB}"
			if [ "${StructureA}" == "${StructureB}" ] ; then

				echo "Running classification target for ${StructureA}"
	
				mkdir ${PRun}/${XHemisphere}${StructureA}

				printf '%s\n' "$Masks/$XHemisphere$StructureA.nii.gz" >> ${PRun}/${XHemisphere}${StructureA}/masks.txt

				/usr/local/fsl/bin/probtrackx2 -x ${PRun}/${XHemisphere}${StructureA}/masks.txt \
				 -l --onewaycondition --cthr=$Curv --nsteps=$NSteps --steplength=$SLength --nsamples=$NSamples --fibthresh=$FThresh --distthresh=$DThresh --sampvox=0.0  --randfib=2 \
				--forcedir --opd --pd -s ${XTBed}/merged -m ${XTBed}/nodif_brain_mask.nii.gz  \
				--dir=${PRun}/${XHemisphere}${StructureA} \
				#--os2t --s2tastext


				printf '%s\n' "$XHemisphere $StructureA" >> ${PRun}/WaytotalSummaryClassification.txt
				var=$(cat "${PRun}/${XHemisphere}${StructureA}/waytotal")
				printf '%s\n' "$var" >> ${PRun}/WaytotalSummaryClassification.txt

				cp ${PRun}/${XHemisphere}${StructureA}/fdt_paths.nii.gz ${PRun}/AllPaths/${XHemisphere}${StructureA}_Paths.nii.gz

			else

				mkdir ${PRun}/${XHemisphere}${StructureA}_${StructureB}

				echo "Making mask textfiles ${StructureA} ${StructureB}"
				printf '%s\n' "$Masks/$XHemisphere$StructureA.nii.gz" "$Masks/$XHemisphere$StructureB.nii.gz" >> ${PRun}/${XHemisphere}${StructureA}_${StructureB}/${StructureA}_${StructureB}.txt
				printf '%s\n' "$Masks/$XHemisphere$StructureA.nii.gz" "$Masks/$XHemisphere$StructureB.nii.gz" >> ${PRun}/${XHemisphere}${StructureA}_${StructureB}/masks.txt

				echo "Running Probtrackx between ${StructureA} ${StructureB}"

				/usr/local/fsl/bin/probtrackx2 --network -x ${PRun}/${XHemisphere}${StructureA}_${StructureB}/masks.txt \
				-l --onewaycondition --cthr=$Curv --nsteps=$NSteps --steplength=$SLength --nsamples=$NSamples --fibthresh=$FThresh --distthresh=$DThresh --sampvox=0.0  --randfib=2 \
				--forcedir --opd --pd -s ${XTBed}/merged -m ${XTBed}/nodif_brain_mask.nii.gz  \
				--dir=${PRun}/${XHemisphere}${StructureA}_${StructureB} \
				--waypoints=${PRun}/${XHemisphere}${StructureA}_${StructureB}/${StructureA}_${StructureB}.txt  \
				--waycond=AND --wtstop=${PRun}/${XHemisphere}${StructureA}_${StructureB}/${StructureA}_${StructureB}.txt
				
				printf '%s\n' "$XHemisphere $StructureA, $StructureB" >> ${PRun}/WaytotalSummaryMasks.txt
				var2=$(cat "${PRun}/${XHemisphere}${StructureA}_${StructureB}/waytotal")
				printf '%s\n' "$var2" >> ${PRun}/WaytotalSummaryMasks.txt

				cp ${PRun}/${XHemisphere}${StructureA}_${StructureB}/fdt_paths.nii.gz ${PRun}/AllPaths/${XHemisphere}${StructureA}_${StructureB}_Paths.nii.gz

			fi
			done	
		done
else	

	for StructureA in ${Structures}; do
		echo ""
		echo ""
		echo ""

		echo "Seed Mask is $XHemisphere$StructureA"

		for StructureB in ${Structures}; do

			echo "Target Mask is $YHemisphere$StructureB"
			
			echo "Processing ${XHemisphere}${StructureA} ${YHemisphere}${StructureB}"
			mkdir ${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}

			echo "Making mask textfiles ${StructureA} ${StructureB}"
			printf '%s\n' "$Masks/$XHemisphere$StructureA.nii.gz" "$Masks/$YHemisphere$StructureB.nii.gz" >> ${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/${StructureA}_${StructureB}.txt
			printf '%s\n' "$Masks/$XHemisphere$StructureA.nii.gz" "$Masks/$XHemisphere$StructureB.nii.gz" >> ${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/masks.txt

			echo "Running Probtrackx between ${XHemisphere}${StructureA} ${YHemisphere}${StructureB}"

				/usr/local/fsl/bin/probtrackx2 --network -x ${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/masks.txt \
				-l --onewaycondition --cthr=$Curv --nsteps=$NSteps --steplength=$SLength --nsamples=$NSamples --fibthresh=$FThresh --distthresh=$DThresh --sampvox=0.0 --randfib=2 \
				--forcedir --opd --pd -s ${XTBed}/merged -m ${XTBed}/nodif_brain_mask.nii.gz  \
				--dir=${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB} \
				--waypoints=${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/${StructureA}_${StructureB}.txt  \
				--waycond=AND --wtstop=${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/${StructureA}_${StructureB}.txt
				
				printf '%s\n' "$XHemisphere $StructureA, ${YHemisphere} $StructureB" >> ${PRun}/WaytotalSummaryMasks.txt
				var2=$(cat "${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/waytotal")
				printf '%s\n' "$var2" >> ${PRun}/WaytotalSummaryMasks.txt

				cp ${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/fdt_paths.nii.gz ${PRun}/AllPaths/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}_Paths.nii.gz

		done	
	done

fi
done

done

for XHemisphere in ${Hemispheres}; do

	for YHemisphere in ${Hemispheres}; do

		if [ "${XHemisphere}" == "${YHemisphere}" ] ; then
			mkdir ${PRun}/${XHemisphere}waytotals
			for StructureA in ${Structures}; do
				for StructureB in ${Structures}; do	
					if [ "${StructureA}" == "${StructureB}" ] ; then
						var1=$(cat "${PRun}/${XHemisphere}${StructureA}/waytotal")
						printf ${var1} >> ${PRun}/${XHemisphere}waytotals/${StructureA}.txt
						printf ' ' >> ${PRun}/${XHemisphere}waytotals/${StructureA}.txt
					
					else
						var2=$(cat "${PRun}/${XHemisphere}${StructureA}_${StructureB}/waytotal")
						printf ${var2} >> ${PRun}/${XHemisphere}waytotals/${StructureA}.txt
						printf ' ' >> ${PRun}/${XHemisphere}waytotals/${StructureA}.txt
					fi
					
				done
				var3=$(cat "${PRun}/${XHemisphere}waytotals/${StructureA}.txt")
				printf '%s\n' "$var3" >> ${PRun}/${XHemisphere}_WaypointTable.txt
			done
			

		else
			mkdir ${PRun}/${XHemisphere}${YHemisphere}waytotals
			for StructureA in ${Structures}; do
				for StructureB in ${Structures}; do	
					var2=$(cat "${PRun}/${XHemisphere}${StructureA}_${YHemisphere}${StructureB}/waytotal")
					printf ${var2} >> ${PRun}/${XHemisphere}${YHemisphere}waytotals/${StructureA}.txt
					printf ' ' >> ${PRun}/${XHemisphere}${YHemisphere}waytotals/${StructureA}.txt

					
				done
				var3=$(cat "${PRun}/${XHemisphere}${YHemisphere}waytotals/${StructureA}.txt")
				printf '%s\n' "$var3" >> ${PRun}/${XHemisphere}${YHemisphere}_WaypointTable.txt

			done
		

		fi
	done
	

done

echo "ProbtrackX Completed"

