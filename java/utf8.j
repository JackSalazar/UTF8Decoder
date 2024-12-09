


//a loop that reads a series of hexadecimal values
//count = 0
//  LOOP
//    - read 1 hexadecimal value, let v_1 be that value
//    - if v_1 > 0xFF, break from the main LOOP
//    - decode character
//    - count ++
//  END LOOP
//  return count



//a set of instructions that decodes each UTF-8 character
//   - let b = bytes_to_read (v_1)
//   - if b == -1, break from LOOP
//   - eliminate the framing bits from v_1
//   - read b-1 hexadecimal values, let v_2, v_3, v_4 be those values
//   - validate each of the values are continuation bytes
//     * if any are not continuation bytes then break from LOOP
//   - eliminate the framing bytes from v2, etc
//   - reassemble the values v_1, ... v_4, as appropriate, into v
//   - print v as a hexadecimal value


public static int decode(){
//      - the pseudo for this method is provided above
//      - it returns the number of UTF-8 characters decoded
   




	return 123456; //modify this laterrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
}

public static int bytes_to_read(int v){
//      - example usage: `b = bytes_to_read(v);`
//      - this method implements the following table
//
//        | Condition               | b = bytes |
//        |-------------------------|----------:|
//        | 0x0000 <= v <=     0x7F |     1     |
//        | 0x0080 <= v <=    0x7FF |     2     |
//        | 0x0800 <= v <=   0xFFFF |     3     |
//        | 0x1000 <= v <= 0x10FFFF |     4     |
//        | otherwise               |    -1     |  
//
//      - see Slide 21 from introduction-to-encodings.pdf
	if (v >= 0x0000){
      if (v <= 0x7F){ //(0111 1111) should be //(0111 1111)
         return 1;
      }
      if (v <= 0x7FF){ // (0111 1111 1111) should be 1101 1111 1011 1111
                       // 111 1111 1111
         return 2;
      }
      if (v <=0xFFFF){ // (1111 1111 1111 1111)
         return 3;
      }
      if (v<= 0x10FFFF){
         return 4;
      }
   }

   return -1; 
}

//public static int isContinuation(int v){
//      - example usage:  value = isContinuation(v);
//      - the implement of this method is as follows:
//        ```java
         public static int isContinuation(int value) {
            // format of value: | ff dd dddd |
            //   where  'f' denotes a framing bit
            //   where  'd' denotes a data bit

            int retval;
         
            retval = 0; //modified so 0 is false
            // eliminate the data bits from value
            value = value & 0xC0;  // 0xC0 == 0b1100 0000

            // ensure the frame bits are "10"
            if (value == 0x80) {   // 0x80 == 0b1000 0000
             retval = 1; //modified so 1 is true
            }
            return retval;
}









