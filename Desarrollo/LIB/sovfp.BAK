FUNCTION b32_2_char( intVal )    && convert Binary 32 Bit (= 4 Byte) to VFP STRING
    LOCAL intLo
    LOCAL intHi
    LOCAL charVal
    
    intLo = INT( intVal % 65536 )
    intHi = INT( intVal / 65536 )
    
    charVal = CHR( INT( intLo % 256 ) );
            + CHR( INT( intLo / 256 ) );
            + CHR( INT( intHi % 256 ) );
            + CHR( INT( intHi / 256 ) )
            
    RETURN charVal
ENDFUNC
FUNCTION char_2_b32( charVal )    && convert VFP STRING to Binary 32 Bit (= 4 Byte)
    LOCAL lenVal
    LOCAL b32Val
    
    lenVal = LEN( charVal )
    
    IF lenVal != 4
        messText = "Error: char_2_b32!"
        
        MESSAGEBOX( messText, 0 + 16 )
        
        RETURN 0
    ENDIF
    
    b32Val = ASC( SUBSTR( charVal, 1, 1 ) );
           + ASC( SUBSTR( charVal, 2, 1 ) ) * 256;
           + ASC( SUBSTR( charVal, 3, 1 ) ) * 256 * 256;
           + ASC( SUBSTR( charVal, 4, 1 ) ) * 256 * 256 * 256
           
    RETURN b32Val
ENDFUNC

FUNCTION getWindowsVersionAndBuildNo()
    LOCAL osVersionInfo
    LOCAL majorVer
    LOCAL minorVer
    LOCAL buildNo
    LOCAL ret
    
    osVersionInfo = b32_2_char( 148 ) + SPACE( 144 )    && Initialize osVersionInfo structure with size=148 = 4+144
    
    DECLARE INTEGER RtlGetVersion IN NTDLL.DLL;
            STRING @osVersionInfo
            
    ret = RtlGetVersion( @osVersionInfo )
    
    IF ret = 0x00000000
        majorVer = char_2_b32( SUBSTR( osVersionInfo, 5, 4 ) )    && 5 is offset, 4 is size in osVersionInfo structure
        minorVer = char_2_b32( SUBSTR( osVersionInfo, 9, 4 ) )    && 9 is offset, 4 is size in ...
        buildNo  = char_2_b32( SUBSTR( osVersionInfo, 13, 4 ) )    && 13 is ...
        MESSAGEBOX("majorVer:"+STR(majorVer) +"   minorVer:"+STR(minorVer) +"   buildNo:"+STR(buildNo) ,0,'')
    ELSE
        messText = "RtlGetVersion - Error: " + ALLTRIM( STR( ret ) )
        
        MESSAEGBOX( messText, 0 + 16 )    
    ENDIF
ENDFUNC