
public static int decode(){

   int count = 0;
   int i = 0;
   int test = 0;

   while (true){
      int bytes2read = 0;
      int v_1;
   
      mips.read_x();
      v_1 = mips.retval();
   
      if (v_1 == -1) {
         return count;
      }
      
      bytes2read = bytes_to_read(v_1); //checks number of bytes to read
   
      if (bytes2read == 2){
         v_1 = v_1 & 0x1F;
      }   
      if (bytes2read == 3){
         v_1 = v_1 & 0x0F;
      }
      if (bytes2read == 4){
         v_1 = v_1 & 0x07;
      }
      //At this point, v_1 has been decoded
   
      int decodedValue = v_1;
   
      for (int j = 1; j < bytes2read; j++){ //The plan is to just add to decodedValue as time goes on, allowing for looping
         mips.read_x();
         int v_cont = mips.retval();
         if (isContinuation(v_cont) == 1){
            v_cont = v_cont & 0x3F;
            decodedValue = decodedValue << 6;
            decodedValue = decodedValue + v_cont;
         } else {
            return -1;
         }
   
      }
      mips.print_x(decodedValue);
      mips.print_c('\n');
      count = count + 1;
      
      i++;
   }
}

public static int bytes_to_read(int v){

	if (v >= 0x0000){
      if (v <= 0x7F){ //(0111 1111) for  encoded it should be 0111 1111 (0x7F)
         return 1;
      }
      if (v <= 0xDF){ // (0111 1111 1111) should be 1101 1111 1011 1111 (0xDF  BF)               
         return 2;
      }
      if (v <=0xEF){ // (1111 1111 1111 1111) should be 1110 1111 1011 1111 1011 1111 (0xEF BF BF)
         return 3;
      }
      if (v<= 0xF4){ // (0001 0000 1111 1111 1111 1111) should be 1111 0111 1011 1111 1011 1111 1011 1111 (0xF7 10 BF BF BF)
         return 4;
      }
   }
   return -1; 
}



public static int isContinuation(int value) {
   int retval;

   retval = 0; //modified so 0 is false
   value = value & 0xC0;  // 0xC0 == 0b1100 0000

   if (value == 0x80) {   // 0x80 == 0b1000 0000
      retval = 1; //modified so 1 is true
   }
   return retval;
}
