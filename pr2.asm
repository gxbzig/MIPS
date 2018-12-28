.text
### Fill Data memory
	ori $1, $0, 1
	ori $2, $0, 26
fill:
	sw $1, -1($1)
	addi $1, $1, 1
	bne $1, $2, fill


### START PROCESSING
	ori $31, $0, 5	## R31 - outer max
	xor $1, $1, $1	## R1 - outer cnt
outer:
	##row_ind_start = 5 * r1 = 4*r1 + r1 = r1<<2 + r1
	##row_ind_end = row_ind_start + 5
	add $2, $1, $0	## R2 = R1
	sll $2, $2, 2		## R2 = R2 * 4
	add $2, $2, $1	## R2 = R2+R1 = row_ind_start
	addi $30, $2, 5	## R30 = R2+5 = row_ind_end
	xor $20, $20, $20	## R20 = row_sum = 0
inner_row:
	lw $10, 0($2)	## R10 = tmp = Mem[ROW][j]
	add $20, $20, $10	## R20 <= row_sum = row_sum+Mem[ROW][j]
	addi $2, $2, 1	## CNT = R2 = R2+1
	bne $2, $30, inner_row
##end inner_row

	## col_ind_start = r1
	## col_ind_end = col_ind_start + 25
	add $3, $1, $0	## R3 = R1 = col_ind_start
	addi $29, $3, 25	## R29 = R3+25 = col_ind_end
	xor $21, $21, $21	## R21 = col_sum = 0
inner_col:
	lw $10, 0($3)	## R10 = tmp = Mem[i][COL]
	add $21, $21, $10 ## R21 <= col_sum = col_sum + mem[i][COL]
	addi $3, $3, 5	## CNT = R3 = R3 + 5
	bne $3, $29, inner_col
##end inner_col

	sub $22, $20, $21	## result <= R22 = R20 - R21
	beq $22, $0, end	## if result == 0, end
	sw $22, 30($1)	## else store result in Mem[30+i]

	addi $1, $1, 1 ## R1 = R1 + 1
	bne $1, $31, outer ## continue if R1 != 5
##end outer
end: 
	ori $17, $zero, 0xffff
finish:
	j finish
