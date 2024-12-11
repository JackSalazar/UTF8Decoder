.text
.globl decode
.globl bytes_to_read
.globl isContinuation
.include "include/stack.s"
.include "include/syscalls.s"
.include "include/subroutine.s"


                                    #
decode:                                    #public static int decode(){
         #Bookkeeping pt.1
         #v0
         #v1
         #a0
         #a1
         #a2
         #a3
         #a4
                                    #
         #t1: count                           #   int count ;
         #t2: i                           #   int i ;
         #t3: bytes2read                           #   int bytes2read;
         #t4: v_1                           #   int v_1;
         #t5: decodedValue                           #   int decodedValue;
         #t6: j                           #   int j;
         #t7: v_cont                           #   int v_cont;
                                    #
         move $t1, $zero                           #   count = 0;
         move $t2, $zero                          #   i = 0;
         move $3, $zero                           #   bytes2read = 0;
                                    #
         .eqv byte2mask, 0x1F                           #   final int byte2mask = 0x1F;
         .eqv byte3mask, 0x0F                           #   final int byte3mask = 0x0F;
         .eqv byte4mask, 0x07                           #   final int byte4mask = 0x07;
         .eqv bytecontmask, 0x3F                           #   final int bytecontmask = 0x3F;
         .eqv decodedValueShift, 6                           #   final int decodedValueShift = 6;
         .eqv negOne, 255                         #   final int negOne = -1;
                                    #   
nextUTFDecode: nop                     #   while (true){
                                    #   
                                    #   
         read_x()                           #      mips.read_x(); CHECK HOW TO DO THESE LINES LATERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
         move $t4, retval()                           #      v_1 = mips.retval();
                                    #   
if1:     bne $t4, negOne, done1                           #      if (v_1 == negOne) {
            move $v0, $t1                        #         return count;
            jr $ra
                                    #      }
done1:                              #      ;      
         call bytes_to_read $t4                           #      bytes2read = bytes_to_read(v_1); //checks number of bytes to read
         move $t3, $v0                           #   
if2:     bne $t3, 2, done2                           #      if (bytes2read == 2){
            and $t4, $t4, byte2mask                        #         v_1 = v_1 & byte2mask;
                                    #      } 
done2:                              #      ;
if3:     bne $t3, 3, done3                            #      if (bytes2read == 3){
            and $t4, $t4, byte3mask                        #         v_1 = v_1 & byte3mask;
                                    #      }
done3:                              #      ;
if4:     bne $t3, 4, done4                           #      if (bytes2read == 4){
            and $t4, $t4, byte4mask                        #         v_1 = v_1 & byte4mask;
                                    #      }
done4:                              #      ;
                                    #      //At this point, v_1 has been decoded
                                    #   
         move $t5, $t4                           #      decodedValue = v_1;
         li $t6, 1                           #      j = 1;
                                    #
nextContBitDecode:   bge $t6, $t3, nextContBitDecodeDone               #      for (;j < bytes2read;){ //The plan is to just add to decodedValue as time goes on, allowing for looping
                                    #         mips.read_x();
                                    #         v_cont = mips.retval();
if5:                                #         if (isContinuation(v_cont) == 1){
                                    #            v_cont = v_cont & bytecontmask;
                                    #            decodedValue = decodedValue << decodedValueShift;
                                    #            decodedValue = decodedValue + v_cont;
                                    #            } //jump to done5
                                    #            else {
                                    #            return -1;
                                    #         }
done5:                              #      ;
next1:                              #      ; 
                                    #      j++;

                     j nextContBitDecode
                                    #      } //jump
nextContBitDecodeDone:                                    #            
                                    #      mips.print_x(decodedValue);
                                    #      mips.print_c('\n');
                                    #      count = count + 1;
next2:                              #        ;
                                    #      i++;
                     j nextUTFDecode
                                    #   }
                                    #}

bytes_to_read:                        #public static int bytes_to_read(int v){
   #Bookkeeping Pt.2
   #a0: v
         .eqv maskOne, 0x7F               #   final int maskone = 0x7F;
         .eqv maskTwo, 0xDF               #   final int masktwo = 0xDF;
         .eqv maskThree, 0xEF               #   final int maskthree = 0xEF;
         .eqv maskFour, 0xF4               #   final int maskfour = 0xF4;
                        #
if6:	   blt $a0, $zero, done6               #   if (v >= 0x0000){
if7:        bgt $a0, maskOne, done7               #      if (v <= maskone){ //(0111 1111) for  encoded it should be 0111 1111 (0x7F)
               li $v0, 1            #         return 1;
               jr $ra
                           #      }
done7:      nop               #        ;
if8:        bgt $a0, maskTwo, done8               #      if (v <= masktwo){ // (0111 1111 1111) should be 1101 1111 1011 1111 (0xDF  BF)               
               li $v0, 2            #         return 2;
               jr $ra
                           #      }
done8:      nop               #        ;
if9:        bgt $a0, maskThree, done9                #      if (v <=maskthree){ // (1111 1111 1111 1111) should be 1110 1111 1011 1111 1011 1111 (0xEF BF BF)
               li $v0, 3            #         return 3;
               jr $ra
                           #      }
done9:      nop               #        ;
if10:       bgt $a0, maskFour, done10               #      if (v<= maskfour){ // (0001 0000 1111 1111 1111 1111) should be 1111 0111 1011 1111 1011 1111 1011 1111 (0xF7 10 BF BF BF)
               li $v0, 4            #         return 4;
               jr $ra
                           #      }
done10:     nop               #         ;
                           #   }
done6:   nop                  #   ;
         li $v0, 255               #   return -1; 
         jr $ra
                        #}
                        #
                        #
                        #
isContinuation:                        #public static int isContinuation(int value) {
         #Bookkeeping Pt.3
         #a0: value
         #t8: retval               #   int retval;
                        #
         .eqv encodeMask, 0xC0               #   final int encodeMask = 0xC0;
         .eqv valueMask, 0x80               #   final int valueMask = 0x80;
                        #
         move $t8, $zero               #   retval = 0; //modified so 0 is false
         and $a0, $a0, encodeMask                #   value = value & encodeMask;  // 0xC0 == 0b1100 0000
                        #
if11:    bne $a0, valueMask, done11               #   if (value == valueMask) {   // 0x80 == 0b1000 0000
         li $t8, 1               #      retval = 1; //modified so 1 is true
                        #   }
done11:                 #   ;
         move $v0, $t8               #   return retval;
         jr $ra
                        #}
