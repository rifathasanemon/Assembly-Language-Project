# Smart Home System 


# In This Program We have 4 main parts (home or not, take temperature, lights status, possibility of
#            finding smoke inside the house)

# 	1: determine if the user is in or not 
#		 H: he is inside, O: if he is outside 
#	2: take the temperature 
# 	should be between 16 and 40 ==> and keeps going down as long as it is >= 16'
#	3: ask the user about what they are planning to do with the light whether turn it on or off  
#		Y for on, N for off 
#	4: check with the user if there is any smoke
#		Y for yes , N for no
#            5:  in case there is no smoke the system will only display “Have a nice day of your own 
#                            home!”
#            6:  in case there is smoke the system will ask the user to immediately get out of the house 
#                       and the power will be cut out

#	Section : 02

# 	Group Members :
#	Emon Rifat Hasan 1832901
#	Amnah Salah Majzob Abdelmaged 1824962
#       Rafi Taufiqul Hafizh 1927529
#       Aly Mennatallah Khaled Mohammad Ramadan 1823048


 .data
selection:			.space 1
roomTemp:			.space 4	
welcomingMsg: 			.asciiz "\nWelcome to Smart Home System." 
inOutHouseMsg:			.asciiz "\n\nAre You Inside Your House or Outside ( 'O' or 'H' ) :"			
onAc:				.asciiz "\nThe Ac is on ...\n\nChecking room temperature (40 - 16 ) :" 
wrongTempMsg:			.asciiz "The room temperature shoud be between 16 and 40 :"	
currentTemp:			.asciiz "\nCurrent temperature is : "
offAc:				.asciiz "\nAC is Off now ."
lightMsg:               	.asciiz "\nWhat do you want to do with the lights:\n keep it turrned on?( 'Y' OR 'N')"
MsgLightOn:             	.asciiz "\n\nLights are on.\n"
MsgLightOff:            	.asciiz "\n\nLights turned off.\n"
scanSmoke:			.asciiz "\nAre there smoke in the house? ( 'Y' OR 'N') : "
alarm:				.asciiz "\nPlease immediately exit the building!"
powerMsg:                       .asciiz "\nCUT POWER!"
enjoyMsg:			.asciiz "\nHave a nice day !"


 .text 
			
	#give the initial values for inputs
	addi $t0 , $zero , 'O' #let t0 = 'O' 
	addi $t1 , $zero , 'H' #let t1 = 'H' 
	addi $s0 , $zero , 'Y' #let t0 = 'Y' 
	addi $s1 , $zero , 'N' #let t1 = 'N' 

	#print the welcoming message
	la $a0, welcomingMsg
	jal printString 
	
	wrongInouptInOut:	
	#determine if the user is inside or outside of the house 
	la $a0, inOutHouseMsg
	jal printString

	#input char 
	li $v0 , 12
	syscall 
	
	beq $v0 , $t0 , outHouse 
	beq $v0, $t1 , inHouse 
	j wrongInouptInOut
	

	
#if user inside house

inHouse: 

	#Values for temperature
	addi $t2 , $zero , 40	#let t2 = 40 
	addi $t3 , $zero , 16 	#let t3 = 16

	
	#switch on AC and lights 
	la $a0 , MsgLightOn
	jal printString 
	
	la $a0 , onAc
	jal printString

	ifWrong:
	#Get the temp
	li $v0 , 5 
	syscall 
	addi $t4 , $v0 , 0 
	
	#sb $v0 , roomTemp($zero) 
	#lb $t4 , roomTemp

	#Error detections if temp is > 40 or temp < 16 try allow user to re input temp
	 blt $t4 , $t3 , wrongTemp
	 bgt $t4 , $t2 , wrongTemp
	 j continue
	 

	
	
	continue:
	
		while:				# try to decrease the temp till it is 16 C 
		la $a0 , currentTemp
		jal printString
		
		li $v0 , 1 
		add $a0 , $zero ,$t4
		syscall 
		
		sub $t4, $t4 , 1
		bgt $t4 , $t3 , while
		
		
 	

	wrongInputLight:	
	#print ask user about light status
	la $a0, lightMsg
	jal printString	    	
	
   	#input regarding the lights 
	li $v0 , 12 
	syscall
	#compare the input with value with $s0 and $s1
	beq $v0 , $s0 , lightOn
	beq $v0, $s1 , lightOff
	j wrongInputLight
		
	
	wrongInputSmoke:	
	la $a0, scanSmoke	#print output message for smoke
	jal printString
	
	li $v0 , 12		#prompt user to input 
	syscall 
	
	beq $v0 , $s0 , endAlarm #check input from user
	beq $v0, $s1 , end 		
	j wrongInputSmoke	#repeat if input is not the same
	
 	
	
	outHouse: 
	la $a0 , offAc 
	jal printString
	
	la $a0 , MsgLightOff 
	jal printString
	
	j wrongInputSmoke
	
	
lightOn:	
	#switch on lights 
	la $a0 , MsgLightOn
	jal printString 
	
	
	j wrongInputSmoke
	
	
lightOff:
 	#switch off lights 
	la $a0 , MsgLightOff
	jal printString
		
	
	j wrongInputSmoke
	
	endAlarm:
	#function when there are smoke in the house
	
	la $a0, alarm
	jal printString
	
	li $v0 , 10 
	syscall 		 

	#function to print the string
	printString:
	li $v0 , 4 
	syscall 
	jr $ra 
	
	# wrong inputs for temperature 
	wrongTemp:
	la $a0, wrongTempMsg
	jal printString 
	
	j ifWrong	
	
	end:
	
	la $a0, enjoyMsg
	jal printString
	
	li $v0 , 10 
	syscall
