{****************************************************************************}
{***                                                                      ***}
{***                      Turbo Pascal TWFile Unit                        ***}
{***                            1.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1998  (P) Szab¢ Andr s 1997/98             ***}
{***                                                                      ***}
{***                      1997.02.16.  - 1998.11.25.                      ***}
{***                                                                      ***}
{****************************************************************************}

{****************************************************************************}
{************************** File Megnyitasa *********************************}
{****************************************************************************}


Function OpenFile(FNev:string;OpenMode:byte):word;assembler;
asm
        PUSH    DS                      { DS megorzese                       }
        LDS     SI,FNev                 { DS:SI=Filenev                      }
        XOR     BX,BX                   { BX=0                               }
        MOV     BL,DS:[SI]              { BX a string hossza                 }
        XOR     AL,AL                   { AL=0                               }
        MOV     DS:[SI+BX+1],AL         { Az utolso byte=0 (string vege jel) }
        MOV     DX,SI                   { DS:DX = FileNev string             }
        INC     DX                      { Az elso byte a string hossza       }
        MOV     AH,$3D                  { $3D DOS megszakitas                }
        MOV     AL,OpenMode             { Menyitasi kod 0:Read 1:Write 2:R/W }
        INT     $21                     { Int $21 -> DOS megszakitas         }
        POP     DS                      { DS visszaallitasa                  }
        JC      @Hiba                   { Ha hiba volt akkor ugras           }
        MOV     IOError,0               { Nincs hiba                         }
        JMP     @Exit                   { Ugras kilepesre                    }
@Hiba:  MOV     IOError,AX              { IOError=AX                         }
@Exit:
end;

{****************************************************************************}
{**************************** File olvasas **********************************}
{****************************************************************************}

Function ReadFile(FHandle:word;var D;Size:word):word;assembler;
asm
        PUSH    DS                      { DS megorzese                       }
        MOV     BX,FHandle              { BX=FileSzam                        }
        LDS     DX,D                    { AX=Memocim                         }
        MOV     AX,$3F00                { $3F DOS alszolgaltatas             }
        MOV     CX,Size                 { CX db byte betoltese               }
        INT     $21                     { Int $21 DOS megszakitas            }
        POP     DS                      { DS visszaallitas                   }
        JC      @Hiba                   { Ha hiba volt akkor ugras           }
        MOV     IOError,0               { Nincs hiba                         }
        JMP     @Exit                   { Ugras kilepesre                    }
@Hiba:  MOV     IOError,AX              { IOError=AX                         }
@Exit:
end;

{****************************************************************************}
{**************************** File iras *************************************}
{****************************************************************************}

Function WriteFile(FHandle:word;var D;Size:word):word;assembler;
asm
        PUSH    DS                      { DS megorzese                       }
        MOV     BX,FHandle              { BX=FileSzam                        }
        LDS     DX,D                    { AX=Memocim                         }
        MOV     AX,$4000                { $3F DOS alszolgaltatas             }
        MOV     CX,Size                 { CX db byte betoltese               }
        INT     $21                     { Int $21 DOS megszakitas            }
        POP     DS                      { DS visszaallitas                   }
        JC      @Hiba                   { Ha hiba volt akkor ugras           }
        MOV     IOError,0               { Nincs hiba                         }
        JMP     @Exit                   { Ugras kilepesre                    }
@Hiba:  MOV     IOError,AX              { IOError=AX                         }
@Exit:
end;

{****************************************************************************}
{*************************** File mutato allitas ****************************}
{****************************************************************************}

Procedure SeekFile(FHandle:word;Pos:longint;From:byte);assembler;
Asm
        MOV     BX,FHandle              { BX=FileSzam                        }
        MOV     AL,From    { Viszonyitas 00:F. Kezdete 01:Aktualis 2:F. vege }
        MOV     AH,$42
        MOV     DX,Word Ptr [Pos]
        MOV     CX,Word Ptr [Pos+2]
        Int     $21
        JC      @Hiba                   { Ha hiba volt akkor ugras           }
        MOV     IOError,0               { Nincs hiba                         }
        JMP     @Exit                   { Ugras kilepesre                    }
@Hiba:  MOV     IOError,AX              { IOError=AX                         }
@Exit:
end;

{****************************************************************************}
{*************************** File lezarasa **********************************}
{****************************************************************************}

Procedure CloseFile(FHandle:word);assembler;
asm
        MOV     BX,FHandle              { BX=FileSzam                        }
        MOV     AX,$3E00                { $3E DOS alszolgaltatas             }
        INT     $21                     { Int $21 DOS megszakitas            }
        JC      @Hiba                   { Ha hiba volt akkor ugras           }
        MOV     IOError,0               { Nincs hiba                         }
        JMP     @Exit                   { Ugras kilepesre                    }
@Hiba:  MOV     IOError,AX              { IOError=AX                         }
@Exit:
end;

{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                             TWFile End                               ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}