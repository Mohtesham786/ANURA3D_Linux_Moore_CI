      !*****************************************************************************
      !                                       ____  _____
      !           /\                         |___ \|  __ \
      !          /  \   _ __  _   _ _ __ __ _  __) | |  | |
      !         / /\ \ | '_ \| | | | '__/ _` ||__ <| |  | |
      !        / ____ \| | | | |_| | | | (_| |___) | |__| |
      !       /_/    \_\_| |_|\__,_|_|  \__,_|____/|_____/
      !
      !
      !	Anura3D - Numerical modelling and simulation of large deformations
      !   and soil�water�structure interaction using the material point method (MPM)
      !
      !	Copyright (C) 2023  Members of the Anura3D MPM Research Community
      !   (See Contributors file "Contributors.txt")
      !
      !	This program is free software: you can redistribute it and/or modify
      !	it under the terms of the GNU Lesser General Public License as published by
      !	the Free Software Foundation, either version 3 of the License, or
      !	(at your option) any later version.
      !
      !	This program is distributed in the hope that it will be useful,
      !	but WITHOUT ANY WARRANTY; without even the implied warranty of
      !	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      !	GNU Lesser General Public License for more details.
      !
      !	You should have received a copy of the GNU Lesser General Public License
      !	along with this program.  If not, see <https://www.gnu.org/licenses/>.
      !
      !*****************************************************************************


      module ModFileIO
         !**********************************************************************
         !
         !     $Revision: 9707 $
         !     $Date: 2022-04-14 14:56:02 +0200 (do, 14 apr 2022) $
         !
         !**********************************************************************
         use ModGlobalConstants

         !implicit none

      contains



         subroutine FileOpenAction(FileUnit, FileName, Action)
            !*************************************************************************************
            !    SUBROUTINE: FileOpenAction
            !
            !    DESCRIPTION:
            !>   Opens a file in binary format and carries out a read/write action on it.
            !
            !>   @param[in] FileUnit : file unit identifier
            !>   @param[in] FileName : name of the file that is opened
            !>   @param[in] Action : action to be carried out on the file ('R'=read, 'W'=write, 'RW'=readwrite)
            !
            !*************************************************************************************
            implicit none

            integer(INTEGER_TYPE), intent(in) :: FileUnit
            character(len=*), intent(in) :: FileName, Action

            ! local variables
            integer(INTEGER_TYPE) :: ios
            logical :: IsOpen
            character(len=10) :: ToDo
            
            ! Using the input action string convert it to something the open file statement can use
            if ( trim(Action) == 'R' ) ToDo = 'Read'
            if ( trim(Action) == 'W' ) ToDo = 'Write'
            if ( trim(Action) == 'RW' ) ToDo = 'ReadWrite'

            ! Check if the file is open
            inquire(unit = FileUnit, opened = IsOpen)

            ! If open close the file
            if ( IsOpen ) close(FileUnit)

            ! If the action is writing erase the file
            if ( trim(Action) == 'W' ) call UniEraseFile(FileName)

           ! WaveHello - removed the intel compiler if statement for the time being to check debugging

            ! Open the file for a TODO action
            ! NOTE: WaveHello - BLOCKSIZE NEEDS to be kept at 4096!! This subroutine is used to write and read the .BRF file and if 4096 isn't used the executable crashes

            !FIXME: Commenting this out to see if the problem with the column collapse is related to this line
            ! open(FileUnit, FILE = FileName, FORM = 'Binary', BLOCKSIZE = 4096, BUFFERCOUNT = 64, BUFFERED = 'no', ACTION = ToDo, IOSTAT = ios)
            open(FileUnit, file=FileName, form='UNFORMATTED', access='STREAM', action=ToDo, iostat=ios)
            call Assert( ios == 0, 'Error opening file: ' // trim(FileName) // ' ' // trim(ToDo) )

         end subroutine FileOpenAction



         subroutine FileOpen(FileUnit, FileName)
            !*************************************************************************************
            !    SUBROUTINE: FileOpen
            !
            !    DESCRIPTION:
            !>   Opens a file.
            !
            !>   @param[in] FileUnit : file unit identifier
            !>   @param[in] FileName : name of the file that is opened
            !
            !*************************************************************************************

            implicit none

            integer(INTEGER_TYPE), intent(in) :: FileUnit
            character(len=*), intent(in) :: FileName

            ! local variables
            integer(INTEGER_TYPE) :: ios
            character(len=1023) :: NameIn, NameOut

            NameIn = Trim(FileName) // ' '
            call GetOrMakeFileName(NameIn, NameOut)
            open(FileUnit, FILE = NameOut, IOSTAT = ios)
            call Assert( ios == 0, 'Error opening file: ' // trim(FileName) )

         end subroutine FileOpen


         !*************************************************************************************
         !    SUBROUTINE: FileOpenWriteBinary
         !
         !    DESCRIPTION:
         !>   Opens a file in binary format for writing content.
         !
         !>   @param[in] FileUnit : file unit identifier
         !>   @param[in] FileName : name of the file that is opened
         !
         !*************************************************************************************
         subroutine FileOpenWriteBinary(FileUnit, FileName)


            implicit none

            integer(INTEGER_TYPE), intent(in) :: FileUnit
            character(len=*), intent(in) :: FileName

            ! local variables
            integer(INTEGER_TYPE) :: ios
            character(len=1023) :: NameIn, NameOut
            
            ! Remove the trailing spaces and 
            NameIn = Trim(FileName) // ' '
            call GetOrMakeFileName(NameIn, NameOut)

            ! Open the file 
            open(FileUnit, file=NameOut, form='UNFORMATTED', access='STREAM', action='WRITE', convert='BIG_ENDIAN', iostat=ios)
            call Assert( ios == 0, 'Error opening file: ' // trim(FileName) )

         end subroutine FileOpenWriteBinary



         subroutine FileOpenAppend(FileUnit, FileName)
            !*************************************************************************************
            !    SUBROUTINE: FileOpenAppend
            !
            !    DESCRIPTION:
            !>   Opens a file for appending its content.
            !
            !>   @param[in] FileUnit : file unit identifier
            !>   @param[in] FileName : name of the file that is opened
            !
            !*************************************************************************************

            implicit none

            integer(INTEGER_TYPE), intent(in) :: FileUnit
            character(len=*), intent(in) :: FileName

            ! local variables
            integer(INTEGER_TYPE) :: ios
            character(len=1023) :: NameIn, NameOut

            NameIn = trim(FileName) // ' '
            call GetOrMakeFileName(NameIn, NameOut)
            open(FileUnit, FILE = NameOut, ACCESS = "APPEND", IOSTAT = ios)
            call Assert( ios == 0, 'Error opening file: ' // trim(FileName) )

         end subroutine FileOpenAppend


         Logical Function FExist(FName)
            !*************************************************************************************
            !    Function: FExist
            !
            !    DESCRIPTION: Check if File "FName" exists
            !
            !*************************************************************************************
            Character FName*(*)
            Logical Tmp
            Tmp=.False.
            goto 2

            Goto 1
            Open( 1,file=FName,Status='OLD',Err=1)
            Tmp=.True.
            Close(1)
    1       Continue
            Inquire(File=FName,Exist=Tmp)
            FExist=Tmp
            Return

    2       Call UniFExist( fName, Tmp )
            FExist=Tmp
            Return
         End

         !*************************************************************************************
         !    Subroutine: FindIO
         !
         !    DESCRIPTION: Returns information of an Open File
         !
         !*************************************************************************************
         Subroutine FindIO(ioMin,io)


            Logical IsOpen
            Parameter (ioMax=99)
            io=ioMin-1
    1       io=io+1
            Inquire(io,Opened=IsOpen)

         End


         SUBROUTINE SKIP(IUNIT,NBYTS)
            !*************************************************************************************
            !    Subroutine: SKIP
            !
            !    DESCRIPTION: Skip reading bytes of block/unit
            !
            !*************************************************************************************

            implicit none
            Character c*1

            integer(INTEGER_TYPE), parameter :: n1 = 1024, nT1 = 8*n1
            integer(INTEGER_TYPE), parameter :: n2 = 128, nT2 = 8*n2
            integer(INTEGER_TYPE), parameter :: n3 = 32, nT3 = 8*n3
            integer(INTEGER_TYPE), parameter :: n4 = 8, nT4 = 8*n4

            real(REAL_TYPE), dimension(n1) :: rBuf1
            real(REAL_TYPE), dimension(n2) :: rBuf2
            real(REAL_TYPE), dimension(n3) :: rBuf3
            real(REAL_TYPE), dimension(n4) :: rBuf4

            integer(INTEGER_TYPE), dimension(:), allocatable :: iBigBuf
            integer(INTEGER_TYPE):: I, IBUF, IERR, IDUM, IUNIT, NDUM, NBYTS

            If (-nByts > 100*nT1) Then
               iBuf = nByts
               Allocate( iBigBuf(iBuf), stat=ierr )
               Read(iUnit) iBigBuf
               nByts = nByts - iBuf
               DeAllocate( iBigBuf )
               Write(2,*)'iBuf : ',iBuf
            End If
            If (nByts > nT1) Then
               nDum = nByts / nT1
               Do i=1,nDum
                  Read(iUnit) rBuf1
               End Do
               nByts = nByts - nT1 * nDum
            End If
            If (nByts > nT2) Then
               nDum = nByts / nT2
               Do i=1,nDum
                  Read(iUnit) rBuf2
               End Do
               nByts = nByts - nT2 * nDum
            End If
            If (nByts > nT3) Then
               nDum = nByts / nT3
               Do i=1,nDum
                  Read(iUnit) rBuf3
               End Do
               nByts = nByts - nT3 * nDum
            End If

            If (nByts > nT4) Then
               nDum = nByts / nT4
               Do i=1,nDum
                  Read(iUnit) rBuf4
               End Do
               nByts = nByts - nT4 * nDum
            End If

            NDUM=NBYTS/4
            DO I=1,NDUM
               READ(IUNIT) IDUM
            End Do

            NByts=NByts-4*NDum
            If (NByts > 0) Then
               Do I=1,NByts
                  READ(IUNIT) C
               End Do
            End If
         end subroutine
         !*************************************************************************************
         !    Function: UpCase
         !
         !    DESCRIPTION: Write name in uppercase
         !
         !*************************************************************************************        
         Character*255 Function UpCase(Lower)
            Character Lower*(*),Tmp*255,C*1

            Tmp=Lower
            LT=Len_Trim(Lower)
            Do i=1,LT
               C=Tmp(i:i)
               j=ichar(c)
               If (j >=  97 .And. j <= 122) Then
                  Tmp(i:i)=Char(j-32)
               End If
            End Do
            Upcase=Tmp
         end function


         Subroutine UniFExist( Name, DoesExist )
            !*************************************************************************************
            !    Subroutine UniFExist
            !
            !    DESCRIPTION: check whether file with possible unicode name exists
            !
            !*************************************************************************************

            Character*(*) Name
            Logical DoesExist
            Character*1023 NameIn, NameOut
            NameIn = Name
            NameIn = Trim(Name)//' '
            Call Get_FileNameIfExists( NameIn, NameOut )
            DoesExist = Len_trim(NameOut) > 1
         End
         
         !*************************************************************************************
         !     Subroutine UniEraseFile
         !
         !    DESCRIPTION:  check whether file with possible unicode name exists,
         !                   when exists, delete it
         !
         !*************************************************************************************
         Subroutine UniEraseFile( Name )

            Character*(*) Name
            Logical DoesExist
            Character*1023 NameIn, NameOut

            NameIn = Name
            NameIn = Trim(Name)//' '
            
            Call Get_FileNameIfExists( NameIn, NameOut )

            DoesExist = Len_trim(NameOut) > 1
            print *, "Length of the trimmed name: ", Len_trim(NameOut)
            If (DoesExist) Then
               Call FindIO(10,io)

               Open(io,file=NameOut)

               ! Try to close and delete the file, if there's an error catch it and branch to continue
               Close(io,Status='Delete',err=1)      
            1    continue
               print *, "Error closing and deleting: ", NameOut
            End If


         end subroutine

         !*************************************************************************************
         !     Subroutine Get_FileNameIfExists
         !
         !    DESCRIPTION:  interface routine to DLL routine to return the 'dos'-name
         !                  for an existing file with utf8-name
         !
         !*************************************************************************************
         Subroutine Get_FileNameIfExists( name, file_exists_char )

            Character*(*), intent(in) :: name
            ! Character tot hold if the file exists 
            ! If the file exists returns the filename if it doesn't returns an empty char ' ' 
            
            Character*1023, intent(inout) :: file_exists_char
            
            ! Local variables
            logical exists

            ! Init to empty char in case the file doesn't exist
            file_exists_char = ' '

            ! Check if the files exists
            Inquire(File = name, Exist = exists)

            ! If the file exists set the file_exists_char to the file name
            If (exists) file_exists_char =  name

         end subroutine
         
         !*************************************************************************************
         !     Subroutine GetOrMakeFileName
         !
         !    DESCRIPTION:  Get or make the name of a File
         !
         !
         !*************************************************************************************
         Subroutine GetOrMakeFileName( Name, ShortName )

            Character*(*) Name
            Character*1023 ShortName

            ShortName = Name

         end subroutine

      end module ModFileIO
