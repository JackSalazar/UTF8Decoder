
public static int decode(){

   int count = 0;
   int i = 0;
   int test = 0;

   final int byte2mask = 0x1F;
   final int byte3mask = 0x0F;
   final int byte4mask = 0x07;
   final int bytecontmask = 0x3F;
   final int decodedValueShift = 6;
   final int negOne = -1;

nextUTFDecode:   while (true){
      int bytes2read = 0;
      int v_1;
   
      mips.read_x();
      v_1 = mips.retval();
   
if1:      if (v_1 == negOne) {
         return count;
      }
done1: ;      
      bytes2read = bytes_to_read(v_1); //checks number of bytes to read
   
if2:      if (bytes2read == 2){
         v_1 = v_1 & byte2mask;
      } 
done2:  ;
if3:      if (bytes2read == 3){
         v_1 = v_1 & byte3mask;
      }
done3:  ;
if4:      if (bytes2read == 4){
         v_1 = v_1 & byte4mask;
      }
done4:  ;
      //At this point, v_1 has been decoded
   
      int decodedValue = v_1;
      int j = 1;

nextContBitDecode:      for (;j < bytes2read;){ //The plan is to just add to decodedValue as time goes on, allowing for looping
         mips.read_x();
         int v_cont = mips.retval();
if5:         if (isContinuation(v_cont) == 1){
            v_cont = v_cont & bytecontmask;
            decodedValue = decodedValue << decodedValueShift;
            decodedValue = decodedValue + v_cont;
else5:         } else {
            return -1;
         }
done5:  ;
next1:   ; 
      j++;
      } //jump
      
      mips.print_x(decodedValue);
      mips.print_c('\n');
      count = count + 1;
next2:  ;
      i++;
   }
}

public static int bytes_to_read(int v){
   final int maskone = 0x7F;
   final int masktwo = 0xDF;
   final int maskthree = 0xEF;
   final int maskfour = 0xF4;

	if (v >= 0x0000){
      if (v <= maskone){ //(0111 1111) for  encoded it should be 0111 1111 (0x7F)
         return 1;
      }
      if (v <= masktwo){ // (0111 1111 1111) should be 1101 1111 1011 1111 (0xDF  BF)               
         return 2;
      }
      if (v <=maskthree){ // (1111 1111 1111 1111) should be 1110 1111 1011 1111 1011 1111 (0xEF BF BF)
         return 3;
      }
      if (v<= maskfour){ // (0001 0000 1111 1111 1111 1111) should be 1111 0111 1011 1111 1011 1111 1011 1111 (0xF7 10 BF BF BF)
         return 4;
      }
   }
   return -1; 
}



public static int isContinuation(int value) {
   int retval;

   final int encodeMask = 0xC0;
   final int valueMask = 0x80;

   retval = 0; //modified so 0 is false
   value = value & encodeMask;  // 0xC0 == 0b1100 0000

   if (value == valueMask) {   // 0x80 == 0b1000 0000
      retval = 1; //modified so 1 is true
   }
   return retval;
}
