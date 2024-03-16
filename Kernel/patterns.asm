[BITS    16]

pattern:
        mov     eax, edi   ; EAX = EDI
        add     eax, ebp   ; EAX = EAX + EBP
        shr     eax, 0x01  ; EAX = (EAX + EBP) / 2

        ret
