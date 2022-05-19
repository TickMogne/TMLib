# TMLib
TickMogne Library for IBMi

## Usage

1. Include the file TMApi_Inc.rpgle in your source
2. Include the file TMLib_Inc.rpgle in your source
3. Compile your program with the INCDIR options including the TMLib 'src' library
for example: INCDIR('/home/user/Development/TMLib/src/')
4. Bind your program with the TMLIB_M binding directory
for example: BndDir('TMLIB_M')

## Files

### src/TMApi_Inc.rpgle

IBMi Api definitions.

### src/TMLib_Inc.rpgle

TMLib definitions.

### src/TMLib_1.rpgle

Module 1 - Codes in fully-free RPGLE language.

### src/TMLib_2.c

Module 2 - Codes in C language.

### src/TMLib_Make.clle

Program to build the TMLIB_M binding directory.
