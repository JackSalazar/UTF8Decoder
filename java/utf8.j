

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


static char [] buffer = new char[3];

// TO DO: CHANGE BYTES_TO_READ TO READ THE ENCODED VERSION OF V_1. FROM THERE, READ ALL REMAINING BYTES THEN MOVE ON TO DECODE ALL OF THEM INSIDE THE BIG LOOP. TWO LOOPS INSIDE EACH OTHER. ONE LOOP TO DECODE THE FIRST UTF, THEN ANOTHER LOOP TO RESTART THE CYCLE AND READ IF THERE'S MORE UTF TO READ

public static int decode(){
//      - the pseudo for this method is provided above
//      - it returns the number of UTF-8 characters decoded
   int count = 0;
   int i = 0;
   int test = 0;
beginning:    ;

entireLoop:   while (i != -1){
   int bytes2read = 0;
   System.out.println("Buffer contents: " + java.util.Arrays.toString(buffer));

   //bytes2read = bytes_to_read(decodedv1); //checks number of bytes to read
    
   int digit = glyph2int(buffer[0], 16); // buffer[0] is the location to read from, while 16 is the radix (base 16) 
   //NOTE: This must be done because it allows you do properly use << and >> respectively. Without it, the letters take on their ascii value, not their true hex value

   //System.out.println(digit);
   // 1101 to 11010
next:   
   i++;
   mips.read_s(buffer, 2);
   }

   //String v_1 = 




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




// dependencies for buffer char to int conversion

public static int glyph2int(char c, int radix) {

    char input = c;
    int digit; 

    //mips.read_c();
    //input = mips.retval();


    if (in_range(input, '0', '9')) {//0' <= input && input <= '9') {
      digit = input - '0';
    }
    else if ( in_range(input, 'A', 'Z')) { //A' <= input && input <= 'Z') {
       digit = input - 'A';
       digit = digit + 10;
    }
    else if (in_range(input, 'a', 'z')) { //a' <= input && input <= 'z') {
       digit = input - 'a';
       digit = digit + 10;
    }
    else {
       digit = -1;
    }

    if (digit > (radix - 1)) {
        digit = -1;
    }

    return digit;
}

public static boolean in_range(char value, char min, char max){
    if (value >= min){
        if (value <= max){
            return true;
        }
    }
    return false;
}




