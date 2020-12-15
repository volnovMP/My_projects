unit CRCCALC;
//--------------------------------------------------------------------
//
// Модуль вычисления циклических контрольных сумм CRC8, CRC16 и CRC32
//
// Версия              - 1
// количество редакций - 1
// Последняя редакция  - 7 октября 2003 года
//
//--------------------------------------------------------------------

//CRC-CCITT-32	has polynomial	X^32+X^26+X^23+X^22+X^16+X^12+X^11+X^10+X^8+X^7+X^4+X^2+X+1
//CRC-CCITT 	has polynomial	X^16+X^12+X^5+1
//CRC-8	    	has polynomial	X^8+x^2+X+1

interface

type
  crc8_t  = BYTE;
  crc16_t = WORD;
  crc32_t = LONGWORD;

function CalculateCRC8(const pData : pchar; dataLen : integer) : crc8_t;
function CalculateCRC16(const pData : pchar; dataLen : integer) : crc16_t;
function CalculateCRC32(const pData : pchar; dataLen : integer) : crc32_t;


const
  crc32_table : array[0..255] of crc32_t =(
  $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f, $e963a535, $9e6495a3,
  $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988, $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,
  $1db71064, $6ab020f2, $f3b97148, $84be41de, $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
  $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec, $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,
  $3b6e20c8, $4c69105e, $d56041e4, $a2677172, $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
  $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
  $26d930ac, $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
  $2802b89e, $5f058808, $c60cd9b2, $b10be924, $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,
  $76dc4190, $01db7106, $98d220bc, $efd5102a, $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
  $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
  $6b6b51f4, $1c6c6162, $856530d8, $f262004e, $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
  $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
  $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
  $4369e96a, $346ed9fc, $ad678846, $da60b8d0, $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
  $5005713c, $270241aa, $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409, $ce61e49f,
  $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,
  $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a, $ead54739, $9dd277af, $04db2615, $73dc1683,
  $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8, $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
  $f00f9344, $8708a3d2, $1e01f268, $6906c2fe, $f762575d, $806567cb, $196c3671, $6e6b06e7,
  $fed41b76, $89d32be0, $10da7a5a, $67dd4acc, $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
  $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
  $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55, $316e8eef, $4669be79,
  $cb61b38c, $bc66831a, $256fd2a0, $5268e236, $cc0c7795, $bb0b4703, $220216b9, $5505262f,
  $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04, $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
  $9b64c2b0, $ec63f226, $756aa39c, $026d930a, $9c0906a9, $eb0e363f, $72076785, $05005713,
  $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38, $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,
  $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
  $88085ae6, $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69, $616bffd3, $166ccf45,
  $a00ae278, $d70dd2ee, $4e048354, $3903b3c2, $a7672661, $d06016f7, $4969474d, $3e6e77db,
  $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
  $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605, $cdd70693, $54de5729, $23d967bf,
  $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94, $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
  );

  crc16_table : array[0..255] of crc16_t =(
  $0000, $1021, $2042, $3063, $4084, $50A5, $60C6, $70E7,
  $8108, $9129, $A14A, $B16B, $C18C, $D1AD, $E1CE, $F1EF,
  $1231, $0210, $3273, $2252, $52B5, $4294, $72F7, $62D6,
  $9339, $8318, $B37B, $A35A, $D3BD, $C39C, $F3FF, $E3DE,
  $2462, $3443, $0420, $1401, $64E6, $74C7, $44A4, $5485,
  $A56A, $B54B, $8528, $9509, $E5EE, $F5CF, $C5AC, $D58D,
  $3653, $2672, $1611, $0630, $76D7, $66F6, $5695, $46B4,
  $B75B, $A77A, $9719, $8738, $F7DF, $E7FE, $D79D, $C7BC,
  $48C4, $58E5, $6886, $78A7, $0840, $1861, $2802, $3823,
  $C9CC, $D9ED, $E98E, $F9AF, $8948, $9969, $A90A, $B92B,
  $5AF5, $4AD4, $7AB7, $6A96, $1A71, $0A50, $3A33, $2A12,
  $DBFD, $CBDC, $FBBF, $EB9E, $9B79, $8B58, $BB3B, $AB1A,
  $6CA6, $7C87, $4CE4, $5CC5, $2C22, $3C03, $0C60, $1C41,
  $EDAE, $FD8F, $CDEC, $DDCD, $AD2A, $BD0B, $8D68, $9D49,
  $7E97, $6EB6, $5ED5, $4EF4, $3E13, $2E32, $1E51, $0E70,
  $FF9F, $EFBE, $DFDD, $CFFC, $BF1B, $AF3A, $9F59, $8F78,
  $9188, $81A9, $B1CA, $A1EB, $D10C, $C12D, $F14E, $E16F,
  $1080, $00A1, $30C2, $20E3, $5004, $4025, $7046, $6067,
  $83B9, $9398, $A3FB, $B3DA, $C33D, $D31C, $E37F, $F35E,
  $02B1, $1290, $22F3, $32D2, $4235, $5214, $6277, $7256,
  $B5EA, $A5CB, $95A8, $8589, $F56E, $E54F, $D52C, $C50D,
  $34E2, $24C3, $14A0, $0481, $7466, $6447, $5424, $4405,
  $A7DB, $B7FA, $8799, $97B8, $E75F, $F77E, $C71D, $D73C,
  $26D3, $36F2, $0691, $16B0, $6657, $7676, $4615, $5634,
  $D94C, $C96D, $F90E, $E92F, $99C8, $89E9, $B98A, $A9AB,
  $5844, $4865, $7806, $6827, $18C0, $08E1, $3882, $28A3,
  $CB7D, $DB5C, $EB3F, $FB1E, $8BF9, $9BD8, $ABBB, $BB9A,
  $4A75, $5A54, $6A37, $7A16, $0AF1, $1AD0, $2AB3, $3A92,
  $FD2E, $ED0F, $DD6C, $CD4D, $BDAA, $AD8B, $9DE8, $8DC9,
  $7C26, $6C07, $5C64, $4C45, $3CA2, $2C83, $1CE0, $0CC1,
  $EF1F, $FF3E, $CF5D, $DF7C, $AF9B, $BFBA, $8FD9, $9FF8,
  $6E17, $7E36, $4E55, $5E74, $2E93, $3EB2, $0ED1, $1EF0
  );

  crc8_table : array[0..255] of crc8_t =(
  $00, $5e, $bc, $e2, $61, $3f, $dd, $83,
  $c2, $9c, $7e, $20, $a3, $fd, $1f, $41,
  $9d, $c3, $21, $7f, $fc, $a2, $40, $1e,
  $5f, $01, $e3, $bd, $3e, $60, $82, $dc,
  $23, $7d, $9f, $c1, $42, $1c, $fe, $a0,
  $e1, $bf, $5d, $03, $80, $de, $3c, $62,
  $be, $e0, $02, $5c, $df, $81, $63, $3d,
  $7c, $22, $c0, $9e, $1d, $43, $a1, $ff,
  $46, $18, $fa, $a4, $27, $79, $9b, $c5,
  $84, $da, $38, $66, $e5, $bb, $59, $07,
  $db, $85, $67, $39, $ba, $e4, $06, $58,
  $19, $47, $a5, $fb, $78, $26, $c4, $9a,
  $65, $3b, $d9, $87, $04, $5a, $b8, $e6,
  $a7, $f9, $1b, $45, $c6, $98, $7a, $24,
  $f8, $a6, $44, $1a, $99, $c7, $25, $7b,
  $3a, $64, $86, $d8, $5b, $05, $e7, $b9,
  $8c, $d2, $30, $6e, $ed, $b3, $51, $0f,
  $4e, $10, $f2, $ac, $2f, $71, $93, $cd,
  $11, $4f, $ad, $f3, $70, $2e, $cc, $92,
  $d3, $8d, $6f, $31, $b2, $ec, $0e, $50,
  $af, $f1, $13, $4d, $ce, $90, $72, $2c,
  $6d, $33, $d1, $8f, $0c, $52, $b0, $ee,
  $32, $6c, $8e, $d0, $53, $0d, $ef, $b1,
  $f0, $ae, $4c, $12, $91, $cf, $2d, $73,
  $ca, $94, $76, $28, $ab, $f5, $17, $49,
  $08, $56, $b4, $ea, $69, $37, $d5, $8b,
  $57, $09, $eb, $b5, $36, $68, $8a, $d4,
  $95, $cb, $29, $77, $f4, $aa, $48, $16,
  $e9, $b7, $55, $0b, $88, $d6, $34, $6a,
  $2b, $75, $97, $c9, $4a, $14, $f6, $a8,
  $74, $2a, $c8, $96, $15, $4b, $a9, $f7,
  $b6, $e8, $0a, $54, $d7, $89, $6b, $35
  );

implementation

// Вычислить циклическую контрольную сумму CRC8
function CalculateCRC8(const pData : pchar; dataLen : integer) : crc8_t;
  var
    n : integer;
    c : crc8_t;
begin
  c := $ff;
  for n := 0 to dataLen-1 do
    c := crc8_table[ byte(pData[n]) xor c ];
  result := c xor $ff;
end;

// Вычислить циклическую контрольную сумму CRC16
function CalculateCRC16(const pData : pchar; dataLen : integer) : crc16_t;
  var
    n : integer;
    c,d,m : crc16_t;
    p : byte;
    r : char;
begin
  c := $ffff;
  for n := 0 to dataLen-1 do
  begin
    d := c shr 8;
    r := pData[n];
    p := byte(r) xor d;
    m := crc16_table[ p ];
    d := crc16_t(c shl 8);
    c := d xor m;
  end;
  result := c xor $ffff;
end;

// Вычислить циклическую контрольную сумму CRC32
function CalculateCRC32(const pData : pchar; dataLen : integer) : crc32_t;
  var
    n   : integer;
    c,m : crc32_t;
    p : byte;
    r : char;
begin
  c := $ffffffff;
  for n := 0 to dataLen-1 do
  begin
    r := pData[n];
    p := (c xor byte(r)) and $ff;
    m := crc32_table[ p ];
    c := c shr 8;
    c := c xor m;
  end;
  result := c xor $ffffffff;
end;

end.
