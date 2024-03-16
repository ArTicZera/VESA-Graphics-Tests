[BITS    16]
[ORG 0x7C00]

%define KERNELLOCAL 0x7E00
%define KERNELSCTRS 0x0008

bootmain:
        ;Setup Data Segments
        xor     ax, ax
        mov     ds, ax
        mov     es, ax

        ;Setup Stack (SP, SS)
        mov     sp, 0x7C00
        mov     ss, ax

        ;Read Kernel Sectors (for VESA)
        mov     ah, 0x02

        mov     bx, KERNELLOCAL
        mov     al, KERNELSCTRS

        mov     ch, 0x00
        mov     dh, 0x00
        mov     cl, 0x02
        
        int     0x13

        ;Jumps to our kernel
        jmp     0x0000:KERNELLOCAL

times 510 - ($ - $$) db 0x00
dw 0xAA55
