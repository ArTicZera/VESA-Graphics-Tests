[BITS    16]

;Common modes:
;  320x200   15bpp -> bx = 0x410D
;  320x200   16bpp -> bx = 0x410E
;  320x200   24bpp -> bx = 0x410F
;  640x400   8bpp  -> bx = 0x4100
;  640x480   8bpp  -> bx = 0x4101
;  640x480   15bpp -> bx = 0x4110
;  640x480   16bpp -> bx = 0x4111
;  640x480   24bpp -> bx = 0x4112
;  800x600   4bpp  -> bx = 0x4102
;  800x600   8bpp  -> bx = 0x4103
;  800x600   15bpp -> bx = 0x4113
;  800x600   16bpp -> bx = 0x4114
;  800x600   24bpp -> bx = 0x4115
;  1024x768  4bpp  -> bx = 0x4104
;  1024x768  8bpp  -> bx = 0x4105
;  1024x768  15bpp -> bx = 0x4116
;  1024x768  16bpp -> bx = 0x4117
;  1024x768  24bpp -> bx = 0x4118
;  1280x1024 4bpp  -> bx = 0x4106
;  1280x1024 8bpp  -> bx = 0x4107
;  1280x1024 15bpp -> bx = 0x4119
;  1280x1024 16bpp -> bx = 0x411A
;  1280x1024 24bpp -> bx = 0x411B
;  1600x1200 8bpp  -> bx = 0x411C
;  1600x1200 15bpp -> bx = 0x411D
;  1600x1200 16bpp -> bx = 0x411E
;  1600x1200 24bpp -> bx = 0x411F

%define VIDEOMODE 0x4101

%define WSCREEN 640
%define HSCREEN 480

SetupVESA:
        call    GetModeInfo
        call    CheckMode
        call    SetMode

        ret

GetModeInfo:
        ;Get 640x480 Info
        mov     di, VBEModeInfo
        mov     cx, VIDEOMODE
        mov     ax, 0x4F01
        int     0x10

        ret

CheckMode:
        ;Check if its compatible
        cmp     [XResolution], word 640
        jne     VESAError
        cmp     [YResolution], word 480
        jne     VESAError
        cmp     [BitsPerPixel], byte 8
        jne     VESAError

        ret

SetMode:
        ;Set video mode to 640x480 8bpp
        mov     ax, 0x4F02
        mov     bx, VIDEOMODE
        int     0x10

        ret

VESAError:
        mov     ah, 0x0E
        mov     al, 'X'
        int     0x10

        cli
        hlt

        jmp     $

VESADebug:
        mov     ax, [XResolution]
        call    printdec

        mov     ah, 0x0E
        mov     al, 0x20
        int     0x10

        mov     ax, [YResolution]
        call    printdec

        mov     ah, 0x0E
        mov     al, 0x20
        int     0x10

        xor     ax, ax
        mov     al, [BitsPerPixel]
        call    printdec

        jmp     $

VBEModeInfo:
        ModeAttributes:      dw 0
        WinAAttributes:      db 0
        WinBAttributes:      db 0
        WinGranularity:      dw 0
        WinSize:             dw 0
        WinASegment:         dw 0
        WinBSegment:         dw 0
        WinFuncPtr:          dd 0
        BytesPerScanLine:    dw 0

        XResolution:         dw 0
        YResolution:         dw 0
        XCharSize:           db 0
        YCharSize:           db 0
        NumberOfPlanes:      db 0
        BitsPerPixel:        db 0
        NumberOfBanks:       db 0
        MemoryModel:         db 0
        BankSize:            db 0
        NumberOfImagePages:  db 0
        Reserved0:           db 1

        RedMaskSize:         db 0
        RedFieldPosition:    db 0
        GreenMaskSize:       db 0
        GreenFieldPosition:  db 0
        BlueMaskSize:        db 0
        BlueFieldPosition:   db 0
        RsvdMaskSize:        db 0
        RsvdFieldPosition:   db 0
        DirectColorModeInfo: db 0

        LFBAddress:          dd 0
        OffScrMemoryOffset:  dd 0
        OffScrMemorySize:    dw 0

        times 206 db 0x00
