
#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#we have used registers to save memory addresses and variables and icnremented them accordingly to run the code
#sorted N numbers

	move $t0,$t3	#variables for copying, t0 has target address
	move $t4,$t2	#t4 has address of the numbers to copied from
	move $s0,$zero	#loop variable for copying
copy:	beq  $s0,$t1 done	#if s0==n done i,e program is complete
	lw   $s1,0($t4)		#loading a[j]
	sw   $s1,0($t0)		#copying a[j] to target address b[j]
	addi $t4,$t4,4		#incrementing the address to access next number to be copied
	addi $t0,$t0,4		#incrementing the address to access next memory location to be copied at
	addi $s0,$s0,1		#incrementing the loop variable
	j copy			#next iteration
done:	move $s0,$t1	#s0=n storing for comparing in loops
	move $s1,$zero #i=0 outer loop variable
	move $s2,$zero #j=0 inner loop variable
	addi $s0,$s0,-1 #s0=n-1 since we need i<n-1
#Bubble sort
#outerloop:	slt $s4,$s1,$s0 #s4=1 if s1<s0 else 0
#	beq $s4,$zero exit#s4=0 i.e i>=n-1 exit outer loop
#	move $s2,$zero 	#j=0 resetting j=0 in every iteration
#	move $t4,$t3	#copying the starting memory address of N numbers to t4
#	sub $s3,$s0,$s1 #upper limit n-i-1 for inner loop
#innerloop:	slt $s5,$s2,$s3	#s5=1 if s2<s3 else 0 i.e checking j<n-i-1
#	beq $s5,$zero innerend #exit inner loop if j>=n-i-1
#	lw $t5,0($t4)	#t5=a[j]
#	lw $t6,4($t4)	#t6=a[j+1]
#	slt $t7,$t6,$t5	#t7=1 if a[j]<a[j+1]
#	addi $t4,$t4,4	#moving to next memory location t4=address of a[j+1]
#	addi $s2,$s2,1 #j+=1
#	beq $t7,$zero innerloop #if a[j]>a[j+1] next iteration or else we swap a[j] and a[j+1]
#	sw $t6,-4($t4) 	#storing a[j+1] into a[j]
#	sw $t5,0($t4)	#storing a[j] into a[j+1]
#	j innerloop 	#continuing inner loop
#innerend:	addi $s1,$s1,1	#incrementing outer loop variable i by 1
#		j outerloop		#jump to next iteration
			
#selection sort
move $s3,$t3  #s3= address first element 
outerloop: slt $s4,$s1,$s0     #checks if i<n-1
	   beq $s4,$zero exit  #if i == n-1 break
	   move $s2,$zero      #j=0
	   addi $t4,$s3,4      # min_address
	   move $s7,$s3      #assuming min element address to be the first element address 
	   sub $s5,$s0,$s1     #upper limit for inner loop n-i-1
innerloop:  slt $s6,$s2,$s5    #checks if j<n-1-i
	   beq $s6,$zero,iend  #if j == n-1-i break
	   lw $t5,0($s7)       #$t5 = a[mid_address]
	   lw $t6,0($t4)       #$t6 = a[j+1]
	   slt $t7,$t6,$t5     #$t7 = 1 if a[j+1]<a[j]
	   addi $t4,$t4,4      # moves to next location
	   addi $s2,$s2,1      #j+=1
	   beq $t7,$zero innerloop
	   addi $s7,$t4,-4      #min address becomes address of a[j+1]
	   j innerloop
iend:  addi $s1,$s1,1         #i+=1
	lw $t8,0($s3)	       #t8 holds a[first]
	lw $t9,0($s7)         #t9 holds a[min]
	sw $t8,0($s7)         #swap values
	sw $t9,0($s3)
	addi $s3,$s3,4      #last pointer 
	j outerloop	
exit:				
#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

