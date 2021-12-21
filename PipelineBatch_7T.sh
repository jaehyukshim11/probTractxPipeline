# Function: main
# Description: main processing work of this script
main()
{
	# Set variable values that locate and specify data to process
	Data="/data/hcp7t" # Location of Subject folders (named by subjectID)
	Subjlist="102311	102816	104416	105923	108323	111312	114823	115017	125525	126426	130518	131217	132118	134829	135124	137128	140117	144226	145834	146735	146937	148133	156334	157336	158035	159239	167036	167440	169343	169444	169747	175237	176542	177140	177645	177746	178142	178647	180533	181232	182436	182739	187345	191033	191841	192439	192641	195041	196144"              # Space delimited list of subject IDs
	ScriptFolder="/data/Scripts"	#Location of script files

	# Set regions for analysis
	Hemispheres="Left Right"
	
	Structures="GPe GPi RN STN SN Striatum"
	
	#ProbtrackX Options
	NSamples="5000" #Number of Samples	
	Curv="0.2"	#Curvature Threshold
	
	NSteps="2000"	#Maximum Number of Steps
	SLength="0.625"	#Step Length
	FThresh="0.01"	#Subsidiary fibre volume threshold
	DThresh="0.01"	#Distance Threshold
	#Minlength="0"	#Minimum length threshold
	FolderName="7T_Run"	#ProbtrackX Folder name in bedpostX folder
	

	echo "Data: ${Data}"
	echo "Subjlist: ${Subjlist}"

	# DO WORK

	mkdir /data/waypointtables/$FolderName

	# Cycle through specified subjects
	for Subject in ${Subjlist} ; do
		echo $Subject
		
		Folder="${Data}/${Subject}/Diffusion_7T"
		echo $Folder
		Image="${Folder}/dti.nii"
		bvals="${Folder}/bvals"
		bvecs="${Folder}/bvecs"
		mask="${Folder}/nodif_brain_mask.nii"
		Masks="${Data}/${Subject}/masks"

		# Run Scripts
		. ${ScriptFolder}/ThresholdAdjustment.sh
		. ${ScriptFolder}/BatchBedpostX.sh 
		. ${ScriptFolder}/ProbtrackX_gpu.sh
		#. ${ScriptFolder}/ProbtrackX.sh
		. ${ScriptFolder}/getwaypointtable7T.sh


		

	done
}

# Invoke the main function to get things started
main "$@"
